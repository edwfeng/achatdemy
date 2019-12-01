import {useParams} from "react-router";
import {Chat, Message} from "./interfaces";
import {useQuery, useMutation} from "@apollo/react-hooks";
import {GET_CHAT} from "./queries";
import {Box, makeStyles, Fab} from "@material-ui/core";
import {TextField, InputBase} from "formik-material-ui";
import React, { useRef, createRef } from "react";
import {Send as SendIcon} from "@material-ui/icons";
import { Formik, Field, FormikActions, FormikProps } from "formik";
import { lightBackground } from "./palette";
import { AuthContext } from "./AuthState";
import ResizeObserver from "react-resize-observer";
import { CREATE_MESSAGE } from "./mutations";
import { MESSAGE_CREATED_SUBSCRIPTION } from "./subscriptions";

const useStyles = makeStyles(theme => ({
    chatMain: {
        width: "100%",
        height: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "stretch"
    },
    chatHeader: {
        borderBottom: `1px solid ${lightBackground}`
    },
    chatBody: {
        height: "100%",
        overflow: "auto",
        paddingBottom: theme.spacing(1)
    },
    chatFooter: {
        borderTop: `1px solid ${lightBackground}`
    },
    ownMessageContainer: {
        textAlign: "right",
        color: "white",
        "& > div": {
            backgroundColor: theme.palette.primary.main
        }
    },
    message: {
        padding: theme.spacing(1),
        backgroundColor: lightBackground,
        borderRadius: theme.spacing(1),
        marginTop: theme.spacing(1),
        marginLeft: theme.spacing(1),
        marginRight: theme.spacing(1),
        width: "auto",
        display: "inline-block"
    },
    messageAuthor: {
        opacity: 0.8,
        fontSize: "70%"
    },
    messageContent: {
        whiteSpace: "pre-wrap"
    },
    chatFooterForm: {
        width: "100%",
        display: "flex",
        padding: theme.spacing(1),
        alignItems: "center"
    },
    chatFooterInput: {
        width: "100%",
        "& > input": {
            width: "100%",
            padding: "0 20px",
            height: "40px",
            borderRadius: "20px",
            backgroundColor: lightBackground,
        }
    },
    chatFooterButtonContainer: {
        paddingLeft: "1em"
    }
}));

type MessageFormValues = {message: string};

export default function ChatComponent() {
    const classes = useStyles();

    const { chatId } = useParams<{chatId: string}>();
    let { data, loading, error, subscribeToMore } = useQuery<{chat: Partial<Chat>}>(GET_CHAT, {variables: {id: chatId}});

    const [createMessage] = useMutation(CREATE_MESSAGE, {update(cache, {data: {create_message}}) {
        const {chat} = cache.readQuery<{chat: Partial<Chat>}>({query: GET_CHAT, variables: {id: chatId}})!;
        cache.writeQuery({
            query: GET_CHAT,
            variables: {id: chatId},
            data: {
                chat: {...chat, messages: (chat.messages || []).filter(msg => msg.id !== create_message.id).concat([create_message])}
            }
        });
    }});

    subscribeToMore<{messageCreated: Message}>({
        document: MESSAGE_CREATED_SUBSCRIPTION,
        variables: {id: chatId},
        updateQuery(prev, {subscriptionData: {data: {messageCreated}}}) {
            return {chat: {...prev.chat, messages: (prev.chat.messages || []).filter(msg => msg.id !== messageCreated.id).concat([messageCreated])}};
        }
    });

    const messageContainerRef = createRef();
    
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
                <Box className={classes.chatHeader}>
                    <h2 style={{margin: "1em"}}>{chat.title || chat.id}</h2>
                </Box>
                <div className={classes.chatBody} ref={messageContainerRef}>
                    <div style={{position: "relative"}}>
                        <AuthContext.Consumer>{auth => {
                            const userId = auth.id;
                            return messages.map(message => {
                                return (
                                    <div key={message.id} className={userId === message.user!.id ? classes.ownMessageContainer : ""}>
                                        <div className={classes.message}>
                                            <div className={classes.messageAuthor}>{message.user!.username || message.user!.id}</div>
                                            <div className={classes.messageContent}>{message.msg || ""}</div>
                                        </div>
                                    </div>
                                );
                            });
                        }}</AuthContext.Consumer>
                        <ResizeObserver onResize={rect => {
                            if (messageContainerRef && messageContainerRef.current) {
                                messageContainerRef.current.scrollTop = rect.height - messageContainerRef.current.clientHeight;
                            }
                        }} />
                    </div>
                </div>
                <Box className={classes.chatFooter}>
                    <Formik initialValues={{message: ""}} validate={(values: MessageFormValues) => {
                        return {}; 
                    }} onSubmit={(values: MessageFormValues, actions: FormikActions<MessageFormValues>) => {
                        createMessage({variables: {chat: chatId, text: values.message}});
                        actions.setValues({message: ""});
                        actions.setSubmitting(false);
                    }} render={(props: FormikProps<MessageFormValues>) => {
                        return (
                            <form onSubmit={props.handleSubmit} className={classes.chatFooterForm}>
                                <Field component={InputBase} className={classes.chatFooterInput} name="message" variant="filled" margin="dense" placeholder="Message" type="text" />
                                <div className={classes.chatFooterButtonContainer}><Fab aria-label="Send message" size="small" color="primary" type="submit"><SendIcon /></Fab></div>
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
