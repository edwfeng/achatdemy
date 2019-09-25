import React from 'react';
import palette from './palette';

const backgroundStyles = {
  backgroundColor: palette.primary.main,
  backgroundImage: `linear-gradient(256deg, ${palette.primary.light}, ${palette.primary.dark})`,
  width: "100%",
  height: "100%"
};

export default class Login extends React.Component {
  render() {
    return (
      <div style={backgroundStyles}><p>Brian很可爱!</p></div>
    );
  }
}
