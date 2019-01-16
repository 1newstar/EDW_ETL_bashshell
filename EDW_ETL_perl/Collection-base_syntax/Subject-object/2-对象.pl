use strict;
use utf8;
binmode(STDIN,  ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

#######################################################
# 不支持私有属性及方法
# 。在 perl 中，一个对象类只不过是一个包
# 创建对象
# 	$object = new My::Object::Class(@args);
# 使用对象
# 	$object_result = $object->method(@args);
# 访问属性
# 	$value = $object -> {‘property_name’};
# 	$object->{‘property_name’} = $value;
# 调用类方法（静态方法）
# 	$result = My::object::class->classmethod(@args);
# 调用对象方法
# 	$result = $object->method(@args);
# 确定一个对象的类名称
# 	$classname = ref($obj);

# 分别成为“调用类方法”和“调用实例方法”。类方法把类名当作第一个参数。它提供针对类的功能，而不是针对某个具体的对象的功能。

# 类方法使用类名作为
# （静态方法） 例子如下：
# 方法的第一个参数。
# sub method {
# my $class = shift;
# ...
# }

# 对象方法使用对象作为第一个参数。
# 例如：
# sub method {
# my $self = shift;
# ...
# }

#######################################################
package Critter;
# sub new { bless {} }
# sub new{return bless{},shift;}
# 如果你希望用户不仅能够用 "CLASS->new()" 这种形式来调用你的构造函数，还能够以 "$obj->new()" 这样的形式来调用的话，那么就这么做
 sub new {
            my $this = shift;
            my $class = ref($this) || $this;
            my $self = {};
            bless $self, $class;
            $self->initialize();
            return $self;
        }
