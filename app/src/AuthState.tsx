import { createContext } from 'react';
import * as React from "react";
import {Route, RouteProps, Redirect} from "react-router";

export class AuthState {
    token: String | undefined;

    invalidate() {
        this.token = undefined;
    }

    get isAuthenticated() {
        return !!this.token;
    }
}

export default AuthState;
export const AuthContext = createContext(new AuthState());

export function PrivateRoute({children, ...rest}: RouteProps) {
    return (
        <AuthContext.Consumer>
            { value => (
                <Route {...rest} render={({location}) => value.isAuthenticated ? children : (
                    <Redirect to={{pathname: "login", state: {from: location}}} />
                )} />
            ) }
        </AuthContext.Consumer>
    );
}
