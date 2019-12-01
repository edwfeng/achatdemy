import {useParams} from "react-router";
import React from "react";
import {useQuery, useMutation} from "@apollo/react-hooks";
import {Community} from "./interfaces";
import {GET_COMM} from "./queries";
import {CREATE_CHAT} from "./mutations";
import {Box, List, ListItem, ListSubheader, makeStyles, Fab, IconButton} from "@material-ui/core";
import {lightBackground} from "./palette";
import {NavLink} from "react-router-dom";
import { AddCircle as Add } from "@material-ui/icons";
import { Formik, FormikProps, Field, FormikActions } from "formik";
import { TextField } from "formik-material-ui";

const styles = makeStyles(theme => ({
    commRoot: {
        display: "flex",
        width: "100%"
    },
    commMain: {
        backgroundColor: lightBackground,
        width: "30%",
        height: "100vh",
        overflow: "auto"
    },
    commHeader: {
        padding: theme.spacing(2)
    },
    commSubheader: {
        backgroundColor: lightBackground
    },
    activeChat: {
        backgroundColor: theme.palette.primary.main,
        color: "white",
        "&:hover, &:focus": {
            backgroundColor: theme.palette.primary.dark
        }
    },
    addChatForm: {
        display: "flex",
        alignItems: "baseline"
    },
    addChatButton: {
        width: "2rem",
        height: "2rem"
    }
}));

export default function Comm({children}: {children: any}) {
    const classes = styles();

    const id = useParams<{commId: string}>().commId;
    const { data, loading, error } = useQuery<{comm: Partial<Community>}, {id: string}>(GET_COMM, {variables: {id}});

    const [createChat] = useMutation(CREATE_CHAT, {update(cache, {data: {create_chat}}) {
        const {comm} = cache.readQuery<{comm: Partial<Community>}>({query: GET_COMM, variables: {id}})!;
        cache.writeQuery({
            query: GET_COMM,
            variables: {id},
            data: {
                comm: {...comm, chats: (comm.chats || []).concat([create_chat])}
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
        const chats = comm.chats || [];
        return (
            <Box className={classes.commRoot}>
                <Box className={classes.commMain}>
                    {comm.name && (<h1 className={classes.commHeader}>{comm.name}</h1>)}
                    <List>
                        <ListSubheader className={classes.commSubheader}>Questions</ListSubheader>
                        {chats.map(chat => {
                            return (
                                <ListItem button key={chat.id} to={`/comms/${id}/chats/${chat.id}`} component={NavLink} activeClassName={classes.activeChat}>
                                    {chat.title || chat.id}
                                </ListItem>
                            );
                        })}
                        <ListItem>
                            <Formik initialValues={{title: ""}} validate={
                                ({title}: {title: string}) => ((!title || title.length < 1) ? {title: "Required."} : {})
                            } onSubmit={async ({title}: {title: string}, actions: FormikActions<{title: string}>) => {
                                try {
                                    await createChat({variables: {title, comm: id}});
                                    actions.setSubmitting(false);
                                    actions.resetForm({title: ""});
                                } catch (e) {
                                    console.log(e);
                                    actions.setErrors({title: "An internal error occurred"});
                                    actions.setSubmitting(false);
                                }
                            }} render={(props: FormikProps<{title: string}>) => { return (
                                <form onSubmit={props.handleSubmit} className={classes.addChatForm}>
                                    <Field component={TextField} name="title" variant="standard" margin="dense" label="Ask a question..." type="text" required />
                                    <IconButton aria-label="New question" size="small" color="primary" type="submit" className={classes.addChatButton}><Add /></IconButton>
                                </form>
                            )}} />
                        </ListItem>
                    </List>
                </Box>
                {children}
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
