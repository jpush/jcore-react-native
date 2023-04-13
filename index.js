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
 static testCountryCode(params) {
   if (Platform.OS == "android") {
      JCoreModule.testCountryCode(params)
   }
 }
 static enableAutoWakeup(enable) {
   if (Platform.OS == "android") {
      JCoreModule.enableAutoWakeup(enable)
   }
 }

}
