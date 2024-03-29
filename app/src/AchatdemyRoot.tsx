import React from 'react';
import palette from './palette';
import { createMuiTheme, CssBaseline } from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
import {Switch, Route, BrowserRouter} from 'react-router-dom';
import Login from './Login';
import AuthState, {PrivateRoute, AuthContext} from "./AuthState";
import Shell from "./Shell";
import {loginPath} from "./Constants";
import {ApolloClient, InMemoryCache} from 'apollo-boost';
import {split} from 'apollo-link';
import {createHttpLink} from 'apollo-link-http';
import {Socket as PhoenixSocket} from 'phoenix';
import * as AbsintheSocket from '@absinthe/socket';
import {createAbsintheSocketLink} from '@absinthe/socket-apollo-link';
import {setContext} from 'apollo-link-context';
import {ApolloProvider} from '@apollo/react-hooks';
import Comm from "./Comm";
import Chat from "./Chat";
import { getMainDefinition } from 'apollo-utilities';
import ManageComm from './ManageComm';

const httpLink = createHttpLink({uri: "/api"});
const wsLink = createAbsintheSocketLink(AbsintheSocket.create(
    new PhoenixSocket("ws://localhost:4000/socket")));
const link = split(({query}) => {
    const definition = getMainDefinition(query);
    return definition.kind === "OperationDefinition" && definition.operation === "subscription";
}, wsLink, httpLink);

class AchatdemyRoot extends React.Component {
  theme = createMuiTheme({
    palette,
    typography: {
      fontFamily: [
        '-apple-system',
        'BlinkMacSystemFont',
        '"Segoe UI"',
        'Roboto',
        '"Helvetica Neue"',
        'Arial',
        'sans-serif',
        '"Apple Color Emoji"',
        '"Segoe UI Emoji"',
        '"Segoe UI Symbol"',
      ].join(',')
    }
  });

  static contextType = AuthContext;
  context: AuthState | undefined;

  client = new ApolloClient({
    link: setContext((_, {headers}) => {
      return {
        headers: {
          ...headers,
          authorization: (this.context && this.context.token) ? `Bearer ${this.context.token}` : ""
        }
      }
    }).concat(link),
    cache: new InMemoryCache()
  });

  render() {
    return (
      <ApolloProvider client={this.client}>
        <BrowserRouter>
          <ThemeProvider theme={this.theme}>
            <CssBaseline />
            <Switch>
                <Route path={loginPath} exact component={Login} />
                <PrivateRoute path="/">
                    <Shell>
                        <Switch>
                            <Route path="/comms/:commId"><Comm>
                                <Switch>
                                    <Route path="/comms/:commId/chats/:chatId"><Chat /></Route>
                                    <Route exact path="/comms/:commId/manage"><ManageComm /></Route>
                                </Switch>
                            </Comm></Route>
                        </Switch>
                    </Shell>
                </PrivateRoute>
            </Switch>
          </ThemeProvider>
        </BrowserRouter>
      </ApolloProvider>
    );
  }
}

export default AchatdemyRoot;
