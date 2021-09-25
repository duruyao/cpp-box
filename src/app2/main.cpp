//
// Created by dry on 7/1/21.
//

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <cJSON.h>
#include <zmq.hpp>

void sayHelloBycJSON() {
    auto root = cJSON_CreateObject();
    cJSON_AddItemToObject(root, "word", cJSON_CreateString("hello, word"));
    std::cout << cJSON_Print(root) << std::endl;
    cJSON_Delete(root);
}

void runZmqServer() {
    zmq::context_t ctx(1);
    zmq::socket_t socket(ctx, ZMQ_REP);
    socket.bind("tcp://*8081");
    for (int n = 9; n--;) {
        zmq::message_t req;
        socket.recv(req, zmq::recv_flags::none);
        std::cout << req.to_string() << std::endl;
    }
}


int main(int argc, char **argv) {
    sayHelloBycJSON();
    return 0;
}
