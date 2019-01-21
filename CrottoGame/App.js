import React, { Component } from 'react';
import welcome from './src/components/views/welcome'

import { createStackNavigator , createAppContainer } from 'react-navigation';

const App = createStackNavigator(
  {
    main : {screen : welcome},
  }
);

export default createAppContainer(App);