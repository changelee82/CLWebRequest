# CLWebRequest 1.0

CLWebRequest 网络框架是基于对 AFNetworking 的二次封装，通过将多个网络请求串行或并行组合起来，从而实现对网络请求的同步或按照指定顺序执行。 <br />

CLWebRequest  封装网络请求 <br />
CLWebRequestQueue   串行的网络请求队列 <br />
CLWebRequestGroup   并行的网络请求组 <br />
CLWebRequestAPI     用于封装业务层 <br />

    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_num"] = @"13000000001";

    // 单一请求
    CLWebRequest *request = [CLWebRequestAPI requestUserRegisters:params];
    request.requestFinishBlock = ^(id json, CLWebRequestError *error)
    {
        if (error == nil)
        {
            self.weatherField.text = [NSString stringWithFormat:@"%@", json[0][@"pollutants"][0][@"value"]];
        }
        else
        {
            NSLog(@"错误信息：%d  %@", error.errorCode, error.errorMessage);
        }
    };
    [request startRequest];
