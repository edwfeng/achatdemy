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
import {createHttpLink} from 'apollo-link-http';
import {setContext} from 'apollo-link-context';
import {ApolloProvider} from '@apollo/react-hooks';
import Comm from "./Comm";

const link = createHttpLink({uri: "/api"});

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
                                    <Route path="/comms/:commId/chats/:chatId"><p style={{width: "100%"}}>Chat</p></Route>
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
