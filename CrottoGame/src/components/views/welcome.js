import React, { Component } from 'react';
import { ScrollView, Text } from 'react-native';

export default class main extends Component {

    static navigationOptions =
        {
            header : null,
        };

    constructor(props) {

        super(props);
        this.state = {
            title : 'Hello World'
        }

    }

    componentWillMount() {

    }

    render() {
        return (
            <ScrollView>
                <Text>
                    {this.state.title}
                </Text>
            </ScrollView>
        );
    }
}





