import java.io.*;

// User类实现Serializable接口
public class list implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String name;
    private transient String password;  // password字段不想被默认序列化

    // 构造函数
    public list(String id, String name, String password) {
        this.id = id;
        this.name = name;
        this.password = password;
    }

    // 自定义序列化方法
    private void writeObject(ObjectOutputStream oos) throws IOException {
        oos.defaultWriteObject();  // 序列化非transient字段
        oos.writeObject(encryptPassword(password));  // 手动序列化密码，并加密处理
    }

    // 自定义反序列化方法
    private void readObject(ObjectInputStream ois) throws IOException, ClassNotFoundException {
        ois.defaultReadObject();  // 反序列化非transient字段
        password = decryptPassword((String) ois.readObject());  // 手动反序列化密码，并解密处理
    }

    // 简单的加密方法
    private String encryptPassword(String password) {
        return "encrypted-" + password;  // 模拟加密
    }

    // 简单的解密方法
    private String decryptPassword(String encryptedPassword) {
        return encryptedPassword.replace("encrypted-", "");  // 模拟解密
    }

    // 重写toString方法，方便查看对象信息
    @Override
    public String toString() {
        return "User{id='" + id + "', name='" + name + "', password='" + password + "'}";
    }

    public static void main(String[] args) {
        // 创建一个User对象
        list l1 = new list("001", "lxl", "mySecretPassword");

        // 序列化对象
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("l1.ser"))) {
            oos.writeObject(l1);
            System.out.println("序列化完成: " + l1);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 反序列化对象
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream("l1.ser"))) {
            list deserializedlist = (list) ois.readObject();
            System.out.println("反序列化完成: " + deserializedlist);
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
