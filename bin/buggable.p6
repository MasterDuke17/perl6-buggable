#!/usr/bin/env perl6
use lib </home/zoffix/CPANPRC/IRC-Client/lib /var/www/tmp/IRC-Client/lib .>;

use IRC::Client;

class Messenger does IRC::Client::Plugin {
    method irc-privmsg-channel ($e) {
        for $.irc.servers.values -> $server {
            for $server.channels -> $channel {
                next if $server eq $e.server and $channel eq $e.channel;

                $.irc.send: :$server, :where($channel), :text(
                    "$e.nick() over at $e.server.host()/$e.channel() says $e.text()"
                );
            }
        }

        $.irc.send: :where<ZoffixW>
                    :text('I spread the messages!')
                    :server<local>;
    }
}

.run with IRC::Client.new:
    :debug
    :plugins[Messenger.new]
    :nick<MahBot>
    :channels<#zofbot>
    :servers{
        freenode => %(
            :host<irc.freenode.net>,
        ),
        local => %(
            :nick<P6Bot>,
            :channels<#zofbot #perl6>,
            :host(%*ENV<IRC_HOST> // 'localhost'),
        )
    }
