import React from 'react';
import { MainPalette, DarkPalette } from './palette';
import { ThemeProvider } from '@material-ui/styles';
import {
  Box,
  Button,
  Checkbox,
  createMuiTheme,
  FormControlLabel,
  Tab,
  Tabs,
  TextField
} from '@material-ui/core';
import logo from './logo.svg';
import {PaletteOptions} from "@material-ui/core/styles/createPalette";

const backgroundStyles = {
  backgroundColor: MainPalette.primary.main,
  backgroundImage: `linear-gradient(256deg, ${MainPalette.primary.light}, ${MainPalette.primary.dark})`,
  width: "100%",
  height: "100%",
  color: "white"
};

enum LoginMode {
  LOGIN,
  REGISTER
}

class LoginForm extends React.Component<{mode: LoginMode}, {}> {
  render() {
    if (this.props.mode === LoginMode.LOGIN) {
      return (
        <React.Fragment>
          <Box><TextField variant="outlined" margin="dense" label="User ID (numeric uuid)" required /></Box>
          <Box><TextField variant="outlined" margin="dense" label="Password" type="password" required /></Box>
          <Box style={{marginTop: "1em"}}><Button variant="outlined" color="secondary">Sign in</Button></Box>
        </React.Fragment>
      );
    } else if (this.props.mode === LoginMode.REGISTER) {
      return (
        <React.Fragment>
          <Box><TextField variant="outlined" margin="dense" label="Username" required /></Box>
          <Box><TextField variant="outlined" margin="dense" label="Email" required type="email" /></Box>
          <Box><TextField variant="outlined" margin="dense" label="Password" type="password" required /></Box>
          <Box><TextField variant="outlined" margin="dense" label="Confirm Password" type="password" required /></Box>
          <FormControlLabel control={
            <Checkbox checked={true} color="secondary" />
          } label={
            <React.Fragment>I agree to our nonexistent Terms of Service and Privacy Policy.</React.Fragment>
          } />
          <Box style={{marginTop: "1em"}}><Button variant="contained" color="secondary">Register</Button></Box>
        </React.Fragment>
      );
    }

    return null;
  }
}

export default class Login extends React.Component<{}, {mode: LoginMode}> {
  state = {mode: LoginMode.LOGIN};

  render() {
    return (
      <ThemeProvider theme={theme => createMuiTheme({...theme, palette: DarkPalette as PaletteOptions})}>
        <div style={backgroundStyles}>
          <img alt="Achatdemy Logo" src={logo} />
          <Tabs value={this.state.mode} onChange={(event, newValue) => {this.setState({...this.state, mode: newValue})}}>
            <Tab label="Login" value={LoginMode.LOGIN} />
            <Tab label="Register" value={LoginMode.REGISTER} />
          </Tabs>
          <LoginForm mode={this.state.mode} />
        </div>
      </ThemeProvider>
    );
  }
}
