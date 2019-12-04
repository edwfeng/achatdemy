import {useParams} from "react-router";
import React from "react";
import {useQuery, useMutation, useApolloClient} from "@apollo/react-hooks";
import {Community, User} from "./interfaces";
import {GET_DETAILED_COMM, GET_USERNAME} from "./queries";
import {Box, List, ListItem, ListSubheader, makeStyles, Fab, IconButton, ListItemIcon, Typography, Paper, Avatar, ListItemSecondaryAction} from "@material-ui/core";
import {lightBackground} from "./palette";
import {NavLink} from "react-router-dom";
import { AddCircle as Add, Person as PersonIcon, RemoveCircle } from "@material-ui/icons";
import { Formik, FormikProps, Field, FormikActions } from "formik";
import { TextField } from "formik-material-ui";
import { CREATE_PERM } from "./mutations";

const styles = makeStyles(theme => ({
    manageRoot: {
        padding: theme.spacing(3)
    },
    managePaper: {
        marginTop: theme.spacing(2)
    },
    managePaperHeader: {
        padding: theme.spacing(1)
    }
}));

export default function ManageComm() {
    const classes = styles();

    const id = useParams<{commId: string}>().commId;
    const { data, loading, error } = useQuery<{comm: Partial<Community>}, {id: string}>(GET_DETAILED_COMM, {variables: {id}});
    const client = useApolloClient();

    const [createPerm] = useMutation(CREATE_PERM, {update(cache, {data: {create_perm}}) {
        const {comm} = cache.readQuery<{comm: Partial<Community>}>({query: GET_DETAILED_COMM, variables: {id}})!;
        cache.writeQuery({
            query: GET_DETAILED_COMM,
            variables: {id},
            data: {
                comm: {...comm, perms: (comm.perms || []).concat([create_perm])}
            }
        });
    }});

    if (error || (!loading && !data)) {
        let message = "Unknown error.";
        if (error) {
            message = error.message;
            if (error.message === "Network error: JSON Parse error: Unrecognized token '<'") {
                message += " This means @edwfeng probably messed something up. Check the network logs for debugging details."
            }
        } else if (!data) {
            message = "Data is undefined.";
        }

        return (
            <div style={{margin: "1em"}}>
                <h3>Whoops! There was an error.</h3>
                <img src="https://imgs.xkcd.com/comics/server_problem.png" alt="xkcd's Server Problem" />
                <p>Image from <a href="https://xkcd.com/1084/">xkcd</a>.</p>
                <p><strong>Message:</strong> {message}</p>
                <p><strong>Comm ID:</strong> {id}</p>
                {error && (<p><strong>Extra information:</strong> {error.extraInfo}</p>)}
            </div>
        );
    } else if (loading) {
        return (
            <div style={{margin: "1em"}}><h3>Loading community details...</h3></div>
        );
    } else if (data!.comm) {
        const comm = data!.comm;
        return (
            <Box className={classes.manageRoot}>
                <h2>Manage "{comm.name}"</h2>
                <Paper className={classes.managePaper}>
                    <Typography className={classes.managePaperHeader} variant="overline" component="h3">People</Typography>
                    <List dense>
                        {comm.perms!.map(perm => {
                            return (
                                <ListItem key={perm.user!.id}>
                                    <ListItemIcon><Avatar><PersonIcon /></Avatar></ListItemIcon>
                                    {perm.user!.username || perm.user!.id}
                                    <ListItemSecondaryAction>
                                        <IconButton edge="end" aria-label="delete">
                                            <RemoveCircle />
                                        </IconButton>
                                    </ListItemSecondaryAction>
                                </ListItem>
                            );                            
                        })}
                        <ListItem>
                            <Formik initialValues={{username: ""}} validate={
                                ({username}: {username: string}) => ((!username || username.length < 1) ? {username: "Required."} : {})
                            } onSubmit={async ({username}: {username: string}, actions: FormikActions<{username: string}>) => {
                                try {
                                    const { data, errors } = await client.query<{user: Partial<User> | undefined}>({query: GET_USERNAME, variables: {username}});
                                    if (errors) {
                                        throw errors[0];
                                    }

                                    if (data && data.user) {
                                        await createPerm({variables: {comm: id, user: data.user.id, def: {admin: true}}});
                                        actions.resetForm({username: ""});
                                    } else {
                                        actions.setErrors({username: "User not found"});
                                    }

                                    actions.setSubmitting(false);
                                } catch (e) {
                                    console.log(e);
                                    actions.setErrors({username: "An internal error occurred"});
                                    actions.setSubmitting(false);
                                }
                            }} render={(props: FormikProps<{username: string}>) => { return (
                                <form onSubmit={props.handleSubmit}>
                                    <Field component={TextField} name="username" variant="standard" margin="dense" label="Add person" placeholder="Username" type="text" required />
                                    <ListItemSecondaryAction>
                                        <IconButton aria-label="New question" size="small" color="primary" type="submit" edge="end" disabled={props.isSubmitting || !props.isValid}>
                                            <Add />
                                        </IconButton>
                                    </ListItemSecondaryAction>
                                </form>
                            )}} />
                        </ListItem>
                    </List>
                </Paper>
            </Box>
        );
    } else {
        return (
            <div style={{margin: "1em"}}>
                <h2>Community not found.</h2>
                <p>You may not have access to the community, or it may simply not exist.</p>
                <p>Try one of the communities on the left.</p>
            </div>
        );
    }
}
