@echo off
:: 需要管理员权限运行
:: 示例：开放TCP 7777，8888端口
netsh advfirewall firewall add rule name="Open_TCP_7777" dir=in action=allow protocol=TCP localport=7777
netsh advfirewall firewall add rule name="Open_TCP_8888" dir=in action=allow protocol=TCP localport=8888

:: 可选：开放UDP 7777，8888端口
netsh advfirewall firewall add rule name="Open_UDP_7777" dir=in action=allow protocol=UDP localport=7777
netsh advfirewall firewall add rule name="Open_UDP_8888" dir=in action=allow protocol=UDP localport=8888

:: 验证规则
netsh advfirewall firewall show rule name="Open_TCP_7777"
netsh advfirewall firewall show rule name="Open_TCP_8888"
netsh advfirewall firewall show rule name="Open_UDP_7777"
netsh advfirewall firewall show rule name="Open_UDP_8888"