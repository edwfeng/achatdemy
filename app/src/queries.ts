import gql from 'graphql-tag';

export const GET_ME = gql`
query GetMe {
    me {
        id
        username
        perms {
            comm {
                id
                name
            }
            commId
        }
    }
}
`;

export const GET_COMM = gql`
query GetComm($id: ID) {
    comm(id: $id) {
        name
        chats {
            id
            title
            type
            userId
        }
    }
}
`;
