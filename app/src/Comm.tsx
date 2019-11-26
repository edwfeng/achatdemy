import {useParams} from "react-router";
import React from "react";
import {useQuery} from "@apollo/react-hooks";
import {Community} from "./interfaces";
import {GET_COMM} from "./queries";
import {Box, List, ListItem, ListSubheader, makeStyles} from "@material-ui/core";
import {lightBackground} from "./palette";
import {NavLink} from "react-router-dom";

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
    }
}));

export default function Comm({children}: {children: any}) {
    const classes = styles();

    const id = useParams<{commId: string}>().commId;
    const { data, loading, error } = useQuery<{comm: Partial<Community>}, {id: string}>(GET_COMM, {variables: {id}});

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
                        <ListSubheader className={classes.commSubheader}>Chats</ListSubheader>
                        {chats.map(chat => {
                            return (
                                <ListItem button key={chat.id} to={`/comms/${id}/chats/${chat.id}`} component={NavLink} activeClassName={classes.activeChat}>
                                    {chat.title || chat.id}
                                </ListItem>
                            );
                        })}
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
