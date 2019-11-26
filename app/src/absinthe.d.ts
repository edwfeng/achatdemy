import { ApolloLink } from "apollo-link";
import { Socket } from "phoenix";

declare module '@absinthe/socket' {
    declare class AbsintheSocket {}
    declare function create(socket: Socket): AbsintheSocket;
}

declare module '@absinthe/socket-apollo-link' {
    declare function createAbsintheSocketLink(socket: AbsintheSocket): ApolloLink;
}
