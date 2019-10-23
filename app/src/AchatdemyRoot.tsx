import React from 'react';
import palette from './palette';
import { createMuiTheme, CssBaseline } from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
import {Switch, Route, BrowserRouter} from 'react-router-dom';
import Login from './Login';

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

  render() {
    return (
      <BrowserRouter>
        <ThemeProvider theme={this.theme}>
          <CssBaseline />
          <Switch>
            <Route path="/login">
              <Login />
            </Route>
          </Switch>
        </ThemeProvider>
      </BrowserRouter>
    );
  }
}

export default AchatdemyRoot;
