import React, { Component } from 'react';
import { StyleSheet ,  TextInput , Alert , Button , Text, View } from 'react-native';

export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
    text: ''  , 
    publickey1 : 'Here will show your Public Key' , 
    newPubKey : 'Here will show your new Public Key' , 
    newSecKey : 'Here will show your new Secret Key (Keep it safe!!)' ,
    destinationKey : ''};
  }

  render() {
    return (
     <View>
         
     </View>
      
    );
  }
}
