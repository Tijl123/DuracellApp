import "dart:io";
import "package:dart_amqp/dart_amqp.dart";

void receive (List<String> arguments) {
    ConnectionSettings settings = new ConnectionSettings(
        host: "http://10.148.22.219:15672"
    );

    Client client = new Client(settings: settings);

    ProcessSignal.sigint.watch().listen((_) {
        client.close().then((_) {
            print("close client");
            exit(0);
        });
    });

    String msg = arguments.isEmpty ? "Hello World!": arguments[0];

    String queueTag = "hello";

    client
        .channel()
        .then((Channel channel) => channel.queue(queueTag, durable: false))
        .then((Queue queue) {
            print(" [*] Waiting for messages in ${queueTag}. To Exit press CTRL+C");
            return queue.consume(consumerTag: queueTag, noAck: true);
        })
        .then((Consumer consumer) {
            consumer.listen((AmqpMessage event) {
                print(" [x] Received ${event.payloadAsString}");
            });
        });
}
