import {useParams} from "react-router";
import {Chat} from "./interfaces";
import {useQuery} from "@apollo/react-hooks";
import {GET_CHAT} from "./queries";
import {Box, makeStyles, Fab} from "@material-ui/core";
import {TextField} from "formik-material-ui";
import React from "react";
import {Send as SendIcon} from "@material-ui/icons";
import { Formik, Field, FormikActions, FormikProps } from "formik";

const useStyles = makeStyles(theme => ({
    chatMain: {
        width: "100%",
        height: "100%"
    }
}));

type MessageFormValues = {message: string};

export default function ChatComponent() {
    const classes = useStyles();

    const { chatId } = useParams<{chatId: string}>();
    let { data, loading, error } = useQuery<{chat: Partial<Chat>}>(GET_CHAT, {variables: {id: chatId}});
    
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
                <h3>Whoops! There was an error loading the chat.</h3>
                <img src="https://imgs.xkcd.com/comics/unreachable_state.png" alt="xkcd's Server Problem" />
                <p>Image from <a href="https://xkcd.com/1084/">xkcd</a>.</p>
                <p><strong>Message:</strong> {message}</p>
                <p><strong>Chat ID:</strong> {chatId}</p>
                {error && (<p><strong>Extra information:</strong> {error.extraInfo}</p>)}
            </div>
        );
    } else if (loading) {
        return (
            <div style={{margin: "1em"}}><h3>Loading chat details...</h3></div>
        );
    } else if (data!.chat) {
        const chat = data!.chat;
        const messages = chat.messages || [];

        return (
            <Box className={classes.chatMain}>
                <Box>
                    <h2 style={{margin: "1em"}}>{chat.title || chat.id}</h2>
                </Box>
                <Box>
                    {messages.map(message => {
                        return (
                            <div key={message.id}>{message.msg || ""}</div>
                        );
                    })}
                </Box>
                <Box>
                    <Formik initialValues={{message: ""}} validate={(values: MessageFormValues) => {
                        return {};
                    }} onSubmit={(values: MessageFormValues, actions: FormikActions<MessageFormValues>) => {
                        actions.setErrors({message: "Not implemented"});
                        actions.setSubmitting(false);
                    }} render={(props: FormikProps<MessageFormValues>) => {
                        return (
                            <form onSubmit={props.handleSubmit}>
                                <Field component={TextField} name="message" variant="filled" margin="dense" label="Message" type="text" />
                                <Fab aria-label="Send message" size="small" color="primary" type="submit"><SendIcon /></Fab>
                            </form>
                        );
                    }} />
                </Box>
            </Box>
        );
    } else {
        return (
            <div style={{margin: "1em"}}>
                <h2>Chat not found.</h2>
                <p>You may not have access to the chat, or it may simply not exist.</p>
                <p>Try one of the chats on the left.</p>
            </div>
        );
    }
}
