const React = require('react-native');
const {
  AppRegistry,
  StyleSheet,
  Text,
  View,
} = React;

const GooglePlusLogin = require('react-native-google-plus-login')

var RCTGooglePlusLoginExample = React.createClass({
  render: function() {
    return (
      <View style={styles.container}>
        <GooglePlusLogin
          clientId='YOUR_CLIENT_ID_HERE'/>
      </View>
    );
  }
});

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('RCTGooglePlusLoginExample', () => RCTGooglePlusLoginExample);
