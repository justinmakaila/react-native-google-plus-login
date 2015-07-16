var React = require('React')
var ReactNativeViewAttributes = require('ReactNativeViewAttributes')
var PropTypes = require('ReactPropTypes')
var createReactNativeComponentClass = require('createReactNativeComponentClass')
var GooglePlusLoginManager = require('NativeModules').RCTGooglePlusLoginManager

var GooglePlusLogin = React.createClass({
  propTypes: {
    permissions: PropTypes.array,
    onLogin: PropTypes.func,
    onLogout: PropTypes.func,
    onLoginFound: PropTypes.func,
    onLoginNotFound: PropTypes.func,
    onError: PropTypes.func,
    onCancel: PropTypes.func,
    onPermissionsMissing: PropTypes.func,
  },

  getInitialState: function () {
    return {
      credentials: null,
    }
  },

  componentWillMount: function () {
    // TODO: Create a listener and call the event handler from props for each event supplied by the GooglePlusLoginManager
  },

  componentWillUnmount: function () {
    // TODO: Remove each listener
  },

  componentDidMount: function() {
    // TODO: Attempt to load credentials
  },

  render: function() {
    return <RCTGooglePlusLogin {...props} />
  }
})

var RCTGooglePlusLogin = createReactNativeComponentClass({
  validAttributes: {
    ...ReactNativeViewAttributes.UIView,
    permissions: true,
  },
  uiViewClassName: 'RCTGooglePlusLogin'
})

module.exports = GooglePlusLogin
