const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
function core(os) {
  const calls=[];
  const native=new Proxy({}, {get:(_, name)=>(...args)=>calls.push({name,args})});
  const source=fs.readFileSync(path.join(__dirname, '../index.js'),'utf8')
    .replace(/import\s*\{[\s\S]*?\}\s*from 'react-native'/, 'const { DeviceEventEmitter, NativeModules, Platform } = react')
    .replace('export default class JCore','module.exports = class JCore');
  const context={module:{exports:{}},react:{DeviceEventEmitter:{},NativeModules:{JCoreModule:native},Platform:{OS:os}}};
  vm.runInNewContext(source,context);
  return {JCore:context.module.exports,calls};
}
test('Core upgrade preserves explicit authorization and Android diagnostic entry points',()=>{
 const {JCore,calls}=core('android'); assert.equal(calls.length,0);
 JCore.setAuth(false);JCore.setCountryCode({code:'fixture'});JCore.enableAutoWakeup(false);
 JCore.enableSDKLocalLog({enable:false,uploadJgToServer:false});const cb=()=>{};JCore.readNewLogs(cb);
 assert.deepEqual(calls.map(x=>x.name),['setAuth','setCountryCode','enableAutoWakeup','enableSDKLocalLog','readNewLogs']);
 assert.equal(calls[0].args[0],false);assert.equal(calls[4].args[0],cb);
});
test('Core iOS keeps original platform support without adding internal SDK APIs',()=>{
 const {JCore,calls}=core('ios');JCore.setAuth(true);JCore.setCountryCode({code:'fixture'});JCore.enableAutoWakeup(true);
 JCore.enableSDKLocalLog({enable:false,uploadJgToServer:false});JCore.readNewLogs(()=>{});
 assert.deepEqual(calls.map(x=>x.name),['setAuth']);
});
