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

export const CREATE_PERM = gql`
mutation CreatePerm($comm: String, $user: String, $def: PermDefInput) {
    create_perm(commId: $comm, userId: $user, perms: $def) {
        user {
            id
            username
        }
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

export const CREATE_WIDGET = gql`
mutation CreateWidget($chat: ID!, $uri: String!, $desc: String) {
    create_widget(chatId: $chat, uri: $uri, desc: $desc) {
        id
        uri
        desc
    }
}
`;
