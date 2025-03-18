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
}
