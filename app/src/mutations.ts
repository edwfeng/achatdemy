import gql from 'graphql-tag';

export const CREATE_MESSAGE = gql`
mutation CreateMessage($chat: ID!, $text: String!) {
    create_message(chatId: $chat, msg: $text) {
        id
        insertedAt
        user {
            id
            username
        }
        msg
    }
}
`;

export const CREATE_COMM = gql`
mutation CreateComm($name: String) {
    create_comm(name: $name) {
        id
        name
    }
}
`;

export const CREATE_CHAT = gql`
mutation CreateChat($comm: ID!, $title: String) {
    create_chat(commId: $comm, title: $title, type: 3) {
        id
        title
        type
        userId
    }
}
`;
