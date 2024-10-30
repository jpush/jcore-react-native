import {
    DeviceEventEmitter,
    NativeModules,
    Platform
} from 'react-native'

const JCoreModule = NativeModules.JCoreModule


export default class JCore {

 static setAuth(auth) {
   JCoreModule.setAuth(auth)
 }
 static setCountryCode(params) {
   if (Platform.OS == "android") {
      JCoreModule.setCountryCode(params)
   }
 }
 static enableAutoWakeup(enable) {
   if (Platform.OS == "android") {
      JCoreModule.enableAutoWakeup(enable)
   }
 }

}
