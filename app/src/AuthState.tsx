import { createContext } from 'react';
import * as React from "react";
import {Route, RouteProps, Redirect} from "react-router";
import {loginPath} from "./Constants";
import {Location} from 'history';

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

function LoginRedirect({location}: {location: Location}) {
    return <Redirect to={{pathname: loginPath, state: {from: location}}} />
}

export function PrivateRoute({component, children, ...rest}: RouteProps) {
    if (component) {
        return (
            <AuthContext.Consumer>
                { value => (
                    <Route {...rest} component={value.isAuthenticated ? component : LoginRedirect} />
                ) }
            </AuthContext.Consumer>
        );
    }

    return (
        <AuthContext.Consumer>
            { value => (
                <Route {...rest} render={({location}) => value.isAuthenticated ? children : (
                    <LoginRedirect location={location} />
                )} />
            ) }
        </AuthContext.Consumer>
    );
}
