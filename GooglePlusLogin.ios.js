const React = require('react-native');
const {
  DeviceEventEmitter,
  NativeModules: {
    GooglePlusLoginManager,
  },
  PropTypes,
} = React

const ReactNativeViewAttributes = require('ReactNativeViewAttributes')
const createReactNativeComponentClass = require('createReactNativeComponentClass')

console.log("YOOOO")

module.exports = class GooglePlusLogin extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      credentials: null,
      subscriptions: [],
    }
  }

  componentWillMount() {
    const {
      subscriptions
    } = this.state

    var events = GooglePlusLoginManager.Events

    // Create a listener and call the event handler from props for each event supplied by the GooglePlusLoginManager
    Object.keys(events).forEach(event => {
      const subscription = DeviceEventEmitter.addListener(events[event], (eventData) => {
        var eventHandler = this.props["on" + event]
        eventHandler && eventHandler(eventData)
      })

      subscriptions.push(subscription)
    })

    // Set the subscriptions
    this.setState({ subscriptions: subscriptions })
  }

  componentWillUnmount() {
    // Remove each listener
    const {
      subscriptions
    } = this.state

    subscriptions.forEach(function (subscription) {
      subscription.remove()
    })
  }

  componentDidMount() {
    // TODO: Attempt to load credentials
  }

  render() {
    const {
      clientId
    } = this.props

    GooglePlusLoginManager.setClientId(clientId)

    return <RCTGooglePlusLogin {...this.props} />
  }
}

const RCTGooglePlusLogin = createReactNativeComponentClass({
  validAttributes: {
    ...ReactNativeViewAttributes.UIView,
    permissions: true,
  },
  uiViewClassName: 'RCTGooglePlusLogin',
})
