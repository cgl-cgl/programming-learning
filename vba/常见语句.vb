' if条件语句
sub test1()
if 条件 then
执行语句
elseif
执行语句
else
执行语句
end if

end sub

' for循环
sub test2()
for i = a to b step n '当n为1时，可以省去step
执行语句
next

end sub

' do while……loop循环
sub test3()
dim i
i = 2
do while 条件
    如果条件为True执行的代码
    ……
    i= i+1
loop

end sub
