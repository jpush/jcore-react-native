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

}
