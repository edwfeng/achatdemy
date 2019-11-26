import { createContext } from 'react';
import * as React from "react";
import {Route, RouteProps, Redirect} from "react-router";
import {loginPath} from "./Constants";
import {Location} from 'history';

export class AuthState {
    constructor(private localStorageToken: string) {}

    _token: string | undefined = localStorage.getItem(this.localStorageToken) || undefined;

    get token() { return this._token; }
    set token(token: string | undefined) {
        this._token = token;
        if (token) {
            localStorage.setItem(this.localStorageToken, token);
        } else {
            localStorage.removeItem(this.localStorageToken);
        }
    }

    invalidate() {
        this.token = undefined;
    }

    get isAuthenticated() {
        return !!this.token;
    }

    get id(): string | undefined {
        if (this.token) {
            try {
                return JSON.parse(atob(this.token.split(".")[1])).sub as string | undefined;
            } catch (e) {
                console.error(e);
            }
        }

        return;
    }
}

export default AuthState;
export const AuthContext = createContext(new AuthState("achatdemy_token"));

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
