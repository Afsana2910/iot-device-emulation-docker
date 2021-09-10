import os, signal
import datetime
import json
def runCommandline(device_config):
    command = "/usr/bin/java -cp /opt/iosynth/target/iosynth-0.0.7-SNAPSHOT-jar-with-dependencies.jar net.iosynth.Mqtt -c /opt/config/config-mqtt.json -d /opt/config/devices/"+device_config
    print(os.system(command))


def process():
    try:
        # iterating through each instance of the proess
        for line in os.popen("ps ax | grep net.iosynth.Mqtt | grep -v grep"):
            fields = line.split()
            # extracting Process ID from the output
            pid = fields[0]
            # terminating process
            os.kill(int(pid), signal.SIGKILL)
        print("Process Successfully terminated")
    except:
        print("Error Encountered while running script")

process()
weekno = datetime.datetime.today().weekday()
currentHour = str(datetime.datetime.now().hour)
with open("/opt/config/devices/configure.json", "r") as f:
    data = json.load(f)
config_file = str(data[currentHour])
runCommandline(config_file)


