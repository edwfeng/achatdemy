import {red} from "@material-ui/core/colors";

export const lightBackground = "#ccd5f0";

export const MainPalette = {
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
};

export const DarkPalette = {
  primary: {main: lightBackground},
  secondary: MainPalette.secondary,
  error: red,
  type: "dark"
};

export const gradient = `linear-gradient(256deg, ${MainPalette.primary.light}, ${MainPalette.primary.dark})`;

export default MainPalette;
