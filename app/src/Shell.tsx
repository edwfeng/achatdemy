import {RouteProps, useHistory} from "react-router";
import React from "react";
import {Button} from "@material-ui/core";
import {AuthContext} from "./AuthState";
import {loginPath} from "./Constants";

export default function Shell({children}: RouteProps) {
    const history = useHistory();

    return (
        <React.Fragment>
            <p>You're in!</p>
            <AuthContext.Consumer>{context => (
                <Button onClick={() => {
                    context.invalidate();
                    history.push(loginPath);
                }}>No</Button>
            )}</AuthContext.Consumer>
            {children}
        </React.Fragment>
    );
}
