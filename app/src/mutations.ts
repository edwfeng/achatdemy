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
