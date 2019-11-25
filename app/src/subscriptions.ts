import gql from 'graphql-tag';

export const MESSAGE_CREATED_SUBSCRIPTION = gql`
subscription MessageCreated($id: ID!) {
    messageCreated(chatId: $id) {
        id
        user {
            id
            username
        }
        msg
        insertedAt
    }
}
`;
