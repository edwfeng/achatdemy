import React from 'react';
import palette from './palette';
import { createMuiTheme, CssBaseline } from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
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
      <ThemeProvider theme={this.theme}>
        <CssBaseline />
        <Login />
      </ThemeProvider>
    );
  }
}

export default AchatdemyRoot;
