##Nginx RTMP Protocol
##Nginx-RTMP is an open source extension module for the Nginx web server that can be used as a media streaming server for both live streams and video on demand using RTMP. This doesn’t come pre-packaged for the operating system, so we’ll need to build Nginx with this module from source code. The first thing we need to do is get some bits. To do so, enter the following:

sudo apt-get install build-essential libpcre3 libpcre3-dev libssl-dev unzip

##This will take some time. Once these are installed we then need to grab the nginx source code. Version 1.8.1 is the latest stable version so we will use that one:

mkdir nginx

cd nginx

wget http://nginx.org/download/nginx-1.8.1.tar.gz

tar -zxvf nginx-1.8.1.tar.gz

##The next thing we will need is the source for Nginx-RTMP:

wget https://github.com/arut/nginx-rtmp-module/archive/master.zip

unzip master.zip

##At this point, we should have a directory named nginx-1.8.1 which contains the Nginx source code, and one named nginx-rtmp-module-master which contains the Nginx-RTMP source code. The next step is to reconfigure the Nginx source to compile with the Nginx-RTMP module:

cd nginx-1.8.1

./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master

##You should see a scroll of text while it is configured,  after which you can make and install nginx:

make

sudo make install

##At this point Nginx will be installed into the /usr/local/nginx directory. To test everything is working let’s fire Nginx up:

sudo /usr/local/nginx/sbin/nginx

##If everything is working as expected, you should now get the Nginx test page if you navigate to your server’s IP address in a web browser. To stop Nginx you need to call the program again and give it the stop command:

sudo /usr/local/nginx/sbin/nginx -s stop

##Now you will need to add the code to configure the RTMP module. This is done in the default config file which is stored with the other files. I’m going to use nano here, but other text editors are available:

sudo nano /usr/local/nginx/conf/nginx.conf

##Go to the end of the file and paste in the following configuration:

rtmp {

    server {

        listen 1935;

        chunk_size 8192;

        application vod {

            play /usr/local/nginx/rtmp;

        }

    }

}

Save and exit the file. In this file, we’ve told Nginx to listen on port 1935 for RTMP, which is the default port.  We’ve also set it to use a chunk size in transfers of 8192 bits. Next, we’ve created an “application” called vod for video on demand. You can have as many of these as you wish, and name them anything you like. We’ve then told it that the vod application will play files from /usr/local/nginx/rtmp directory. This directory doesn’t actually exist yet, so you will need to create it and place some media into it. Note that Nginx-RTMP can only serve flash flv video and mp4 video.

sudo mkdir /usr/local/nginx/rtmp

The next thing to do is start Nginx again, at which point everything is configured and ready for use:  

sudo /usr/local/nginx/sbin/nginx

To test you just need to open a stream from your server.  The easiest method is to use VLC media player. To open this, go to the “Media” menu and then select “Open Network Stream”. A window will open for you where you can enter the URL for your media.  

The URL will start with rtmp:// to tell VLC the protocol to use, and then the domain name or IP address of your server. Next will be a slash, then your application name, in our case “vod”, another slash and finally the filename of the file. So as an example:

rtmp://your-domain.com/vod/test.mp4

rtmp://your-domain.com/vod/test.flv

So there you have it – a simple streaming server using RTMP based on open source components. Happy streaming!
