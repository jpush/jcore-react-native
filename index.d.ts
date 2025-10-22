// 定义 JCore 类的类型声明
export default class JCore {
    /**
     * 设置认证信息
     * @param auth 是否启用认证
     */
    static setAuth(auth: boolean): void;

    /**
     * 设置国家代码
     * @param params 包含国家代码的对象，字段为 { code: string }
     */
    static setCountryCode(params: { code: string }): void;

    /**
     * 启用自动唤醒功能
     * @param enable 是否启用自动唤醒
     */
    static enableAutoWakeup(enable: boolean): void;

    /**
      * 启用SDK本地日志，启动用SDK日志缓存本设备
      * @param enable 是否启用日志（true表示启用，false表示禁用）
      * @param uploadJgToServer 是否将日志上传到极光服务器（true表示上传，false表示不上传）
    */
    static enableSDKLocalLog(params: {enable: boolean, uploadJgToServer: boolean}): void;

    /**
      * 获取所有进程的新增SDK日志
      *
      * @param {Function} callback = (result) => {"logs":String}
    */
    static readNewLogs(callback: Callback<{ logs: string }>): void;
}
