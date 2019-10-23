import React from 'react';
import { MainPalette, DarkPalette } from './palette';
import { ThemeProvider } from '@material-ui/styles';
import { Formik, Field, Form, FormikProps, FormikActions } from 'formik';
import { TextField } from 'formik-material-ui';
import {
  Box,
  Button,
  Checkbox,
  createMuiTheme,
  FormControlLabel,
  Tab,
  Tabs,
  TextField as MuiTextField
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

interface LoginFormValues {
  username: string;
  password: string;
}

class LoginForm extends React.Component<{mode: LoginMode}, {}> {
  render() {
    if (this.props.mode === LoginMode.LOGIN) {
      return (
        <Formik initialValues={{username: "s", password: ""}} validate={(values: LoginFormValues) => {
          let errors = {};
          if (!values.username || values.username.length < 1) {
            errors.username = "Required."
          }
          if (!values.password || values.password.length < 1) {
            errors.password = "Required."
          }
          return errors;
        }} onSubmit={async (values: LoginFormValues, actions: FormikActions<LoginFormValues>) => {
          // TODO: Move elsewhere
          console.log(values);
          const response = await fetch("/api/auth", {method: "POST", body: JSON.stringify(values)});
          console.log(`Got token: ${await response.json()}`);
          actions.setSubmitting(false);
        }} render={(props: FormikProps<LoginFormValues>) => (
              <form onSubmit={props.handleSubmit}>
                <Box><Field component={TextField} name="username" variant="outlined" margin="dense" label="Username" type="text" required /></Box>
                <Box><Field component={TextField} name="password" variant="outlined" margin="dense" label="Password" type="password" required /></Box>
                <Box style={{marginTop: "1em"}}><Button variant="outlined" color="secondary" type="submit">Sign in</Button></Box>
              </form>
        )} />
      );
    } else if (this.props.mode === LoginMode.REGISTER) {
      return (
        <React.Fragment>
          <Box><MuiTextField variant="outlined" margin="dense" label="Username" required /></Box>
          <Box><MuiTextField variant="outlined" margin="dense" label="Email" required type="email" /></Box>
          <Box><MuiTextField variant="outlined" margin="dense" label="Password" type="password" required /></Box>
          <Box><MuiTextField variant="outlined" margin="dense" label="Confirm Password" type="password" required /></Box>
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
          <LoginForm mode={this.state.mode} />
        </div>
      </ThemeProvider>
    );
  }
}
