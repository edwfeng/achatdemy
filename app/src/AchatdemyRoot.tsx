import React from 'react';
import {Button, createMuiTheme, CssBaseline} from '@material-ui/core';
import { ThemeProvider } from '@material-ui/styles';
import { red } from "@material-ui/core/colors";

class AchatdemyRoot extends React.Component {
  theme = createMuiTheme({
    palette: {
      primary: {
        light: "#383e67",
        main: "#0C183C",
        dark: "#000018"
      },
      secondary: {
        light: "#ffe669",
        main: "#F6B436",
        dark: "#bf8500"
      },
      error: red
    },
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
        <p>Hello, wld!</p>
        <Button variant="outlined" color="primary">Useless button</Button>
      </ThemeProvider>
    );
  }
}

export default AchatdemyRoot;
