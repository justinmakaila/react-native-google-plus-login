var {
  DeviceEventEmitter,
  NativeModules: {
    GooglePlusLoginManager,
  },
  PropTypes,
} = require('react-native');

var ReactNativeViewAttributes = require('ReactNativeViewAttributes')
var createReactNativeComponentClass = require('createReactNativeComponentClass')

var GooglePlusLogin = React.createClass({
  statics: {
    Events: GooglePlusLoginManager.Events,
  },

  propTypes: {
    clientId: PropTypes.string,
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
      subscriptions: [],
    }
  },

  componentWillMount: function () {
    var _this = this
    var subscriptions = _this.state.subscriptions
    var events = GooglePlusLoginManager.Events

    // Create a listener and call the event handler from props for each event supplied by the GooglePlusLoginManager
    Object.keys(events).forEach(function (event) {
      const subscription = DeviceEventEmitter.addListener(events[event], (eventData) => {
        var eventHandler = _this.props["on" + event]
        eventHandler && eventHandler(eventData)
      })

      subscriptions.push(subscription)
    })

    // Set the subscriptions
    this.setState({ subscriptions: subscriptions })
  },

  componentWillUnmount: function () {
    // Remove each listener
    var subscriptions = this.state.subscriptions

    subscriptions.forEach(function (subscription) {
      subscription.remove()
    })
  },

  componentDidMount: function() {
    // TODO: Attempt to load credentials
  },

  render: function() {
    GooglePlusLoginManager.setClientId(this.props.clientId)

    return <RCTGooglePlusLogin {...this.props} />
  },
})

var RCTGooglePlusLogin = createReactNativeComponentClass({
  validAttributes: {
    ...ReactNativeViewAttributes.UIView,
    permissions: true,
  },
  uiViewClassName: 'RCTGooglePlusLogin',
})

module.exports = GooglePlusLogin
