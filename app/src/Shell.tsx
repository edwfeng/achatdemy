import {RouteProps, useHistory} from "react-router";
import React from "react";
import {
    IconButton,
    Button,
    createMuiTheme,
    Drawer,
    makeStyles,
    Menu,
    MenuItem,
    List, ListItem, Divider, Dialog, DialogTitle, Box, DialogContent
} from "@material-ui/core";
import {AuthContext} from "./AuthState";
import {loginPath} from "./Constants";
import {DarkPalette, gradient} from "./palette";
import {PaletteOptions} from "@material-ui/core/styles/createPalette";
import {ThemeProvider} from "@material-ui/styles";
import logo from "./logo.svg";
import {AllInbox as AllIcon, Settings as SettingsIcon, Add as AddIcon, Close as CloseIcon} from '@material-ui/icons';
import {Field, Formik, FormikActions, FormikProps} from "formik";
import {TextField} from "formik-material-ui";
import {useQuery} from "@apollo/react-hooks";
import {GET_ME} from "./queries";

const drawerWidth = 128;

const useStyles = makeStyles(theme => ({
    root: {
        display: "flex"
    },
    drawer: {
        width: drawerWidth,
        flexShrink: 0
    },
    paper: {
        width: drawerWidth,
        backgroundColor: theme.palette.primary.main,
        backgroundImage: gradient,
        borderRight: "none",
        color: "white"
    },
    selectedComm: {
        backgroundColor: theme.palette.secondary.main,
        color: "black",
        "&:hover": {
            backgroundColor: theme.palette.secondary.dark
        },
        "&:focus": {
            backgroundColor: theme.palette.secondary.dark
        }
    },
    newCommDialog: {
        backgroundColor: theme.palette.primary.main,
        backgroundImage: gradient,
        color: "white",
        width: "100%",
        maxWidth: "500px"
    },
    closeButton: {
        position: "absolute",
        right: theme.spacing(1),
        top: theme.spacing(1)
    },
    center: {
        marginLeft: "auto",
        marginRight: "auto",
        textAlign: "center"
    }
}));

export default function Shell({children}: RouteProps) {
    const history = useHistory();
    const classes = useStyles();
    const [anchorEl, setAnchorEl] = React.useState<(EventTarget & Element) | null>(null);
    const [newCommOpen, setNewCommOpen] = React.useState<boolean>(false);

    const me = useQuery<{me: User}>(GET_ME);

    const openAuthMenu = (event: React.MouseEvent) => {
        setAnchorEl(event.currentTarget);
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    return (
        <div className={classes.root}>
                <Drawer variant="permanent" className={classes.drawer} classes={{paper: classes.paper}}>
                    <ThemeProvider theme={theme => createMuiTheme({...theme, palette: DarkPalette as PaletteOptions})}>
                        <img alt="Achatdemy Logo" src={logo} style={{margin: "1em 1.5em"}} />
                        <div style={{margin: "0 auto"}}>
                            <span style={{marginRight: "0.1em"}}>{(me.data && me.data.me.username) || ""}</span>
                            <IconButton size="small" onClick={openAuthMenu} style={{margin: "0"}}><SettingsIcon /></IconButton>
                        </div>
                        <Menu id="auth-menu" anchorEl={anchorEl} keepMounted open={!!anchorEl} onClose={handleClose}>
                            <AuthContext.Consumer>{context => <MenuItem onClick={() => {
                                handleClose();
                                context.invalidate();
                                history.push(loginPath);
                            }}>Log out</MenuItem>}</AuthContext.Consumer>
                        </Menu>
                        <List>
                            <Divider />
                            <ListItem button className={classes.selectedComm}><AllIcon style={{margin: "0.2em"}} /> All</ListItem>
                            <Divider />
                            <ListItem dense button>Achatdemy Team</ListItem>
                            <ListItem dense button>ATCS</ListItem>
                            <ListItem dense button>Class of 2022</ListItem>
                            <ListItem dense button>BCA</ListItem>
                            <ListItem dense button>Comp Sci Club</ListItem>
                            <Divider />
                            <ListItem button onClick={() => setNewCommOpen(true)}><AddIcon style={{margin: "0.2em"}} /> New</ListItem>
                        </List>
                    </ThemeProvider>
                </Drawer>
            {children}
            <ThemeProvider theme={theme => createMuiTheme({...theme, palette: DarkPalette as PaletteOptions})}>
                <Dialog open={newCommOpen} onClose={() => setNewCommOpen(false)} classes={{paper: classes.newCommDialog}}>
                    <DialogTitle style={{textAlign: "center"}}>Create a community <IconButton className={classes.closeButton} onClick={() => setNewCommOpen(false)}>
                        <CloseIcon />
                    </IconButton></DialogTitle>
                    <DialogContent style={{width: "100%"}}>
                        <p className={classes.center} style={{marginTop: "5em", marginBottom: "1em"}}>
                            Create a community to ask questions about a particular topic.
                        </p>
                        <Formik initialValues={{name: ""}} validate={
                            ({name}: {name: string}) => ((!name || name.length < 1) ? {name: "Required."} : {})
                        } onSubmit={({name}: {name: string}, actions: FormikActions<{name: string}>) => {
                            try {
                                actions.setSubmitting(false);
                                setNewCommOpen(false);
                            } catch (e) {
                                actions.setErrors({name: "An internal error occurred"});
                                actions.setSubmitting(false);
                            }
                        }} render={(props: FormikProps<{name: string}>) => { return (
                            <form onSubmit={props.handleSubmit}>
                                <Box className={classes.center}>
                                    <Field component={TextField} name="name" variant="outlined" margin="dense" label="Name" type="text" required />
                                </Box>
                                <Box className={classes.center} style={{margin: "1em 0"}}>
                                    <Button variant="outlined" color="secondary" type="submit" disabled={props.isSubmitting || !props.isValid}><AddIcon /> Create</Button>
                                </Box>
                            </form>
                        )}} />
                    </DialogContent>
                </Dialog>
            </ThemeProvider>
        </div>
    );
}
