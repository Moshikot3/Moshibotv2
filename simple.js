 const http = require("http");
const url = require('url');
const fs = require('fs');

const request = require('request');

const qrcode = require("qrcode-terminal");
const { Client } = require('whatsapp-web.js');

const SESSION_FILE_PATH = './session.json';

let client;

const spam = true;
const checkToken = true;


const chatBot = true;
const chatBotURL = "http://localhost/";
let sessionData;

let sessao;
let sessobj;

if(fs.existsSync(SESSION_FILE_PATH)) {
    //sessionData = require(SESSION_FILE_PATH);

    sessao = fs.readFileSync(SESSION_FILE_PATH);
    sessobj = JSON.parse(sessao);


    //console.log(sessobj);
    //console.log(sessao.toString());
    //return;

    client = new Client({
      session: sessobj
    });

} else {
  client = new Client();
}






const QRCode = require('qrcode');

estado = 0;

let autorizadosArquivo = fs.readFileSync("./autorizados.json");
let autorizados = JSON.parse(autorizadosArquivo);

let token = JSON.parse(fs.readFileSync("./token.json"));
/*
function redirectChatBot(timestamp, sender, message){

  try {

  request(chatBotURL +"?timestamp=" +timestamp +"&sender=" +sender +"&message=" +message, function (error, response, body) {
    if (!error && response.statusCode == 200) {
        console.log("Forwarded to ChatBot API")
     } else {
       console.log("Chatbot did not recieve the message");
     }
})

  } catch(e) {
    console.log("Error calling chatbot API");
  }
  

}
*/

function checaToken(__token){


  
    if (token.token == __token) {
      console.log(__token);
      return true;
    } else {
      return false;
    }
  


}


function checaAutorizados(__number) {

  if (spam == true){
    autorizanumber(__number);
  }

    for (x = 0; x < autorizados.length; x++) {
      if (autorizados[x].number === __number) {
        return autorizados[x];
      }
    }
    return autorizados[0];
  }


function autorizanumber(__number) {
    autorizados.push({ number: __number});
    let data = JSON.stringify(autorizados);
    fs.writeFileSync("./autorizados.json", data);

  }

unread = [];

client.on('qr', (qr) => {
    estado = 0;
    console.log("Waiting for QRCode reading", qr);
    qrcode.generate(qr, {small: true});
    QRCode.toFile('qrcode.png', qr);

});

client.on('ready', () => {
    estado = 1;
    console.log('Ready');
});

client.on('message', async (msg) => {
    if(msg.body === 'קובי תן תיוג') {
		
        const chat = await msg.getChat();
		//Get sender name
		//const author = await msg.getContact();
        
        let text = "";
        let mentions = [];

        for(let participant of chat.participants) {
            const contact = await client.getContactById(participant.id._serialized);
            
            mentions.push(contact);
            text += `@${participant.id.user} `;
        }

        await msg.reply("מתייג את כולם:\n"+text,"", { mentions });
    }
});

client.on('message', message => {
	if(message.body === '!ping') {
		message.reply('pong');
    console.log
	}
});

client.on('message', async (msg) => {
    
    console.log('Message from: ', msg.from, " - ", msg.body);
    const author = await msg.getContact();
    let date = new Date();
    
    unread.push({ timestamp: date.getTime(), messageid: msg.id._serialized, sender: msg.from, sendername: author.pushname ,message: msg.body });


    if (checaAutorizados(msg.from).number == "00000000000"){
        console.log("Number " +msg.from +" Successfully authorized!");
      autorizanumber(msg.from);
      }

});


 client.initialize();


 client.on('authenticated', (session) => {
  sessionData = session;
  fs.writeFile(SESSION_FILE_PATH, JSON.stringify(session), function (err) {
      if (err) {
          console.error(err);
      }
  });
});


const server = http.createServer(function(req, res){
    x = url.parse(req.url, { parseQueryString: true });


//    let ip = req.header('x-forwarded-for') || ;


    //console.log(req.connection.remoteAddress);

    
    if (req.method === 'POST') {
      let body = '';
      req.on('data', chunk => {
          body += chunk.toString(); // convert Buffer to string
      });
      req.on('end', () => {
          ___number = JSON.parse(body).destination +"";
          ___message = JSON.parse(body).message +"";
          ___messageid = JSON.parse(body).messageid;
          ___token = JSON.parse(body).token;

          console.log(checaToken(___token));
  

          if (checaAutorizados(___number).number == "00000000000"){
            console.log("Attempt to send with invalid token via POST");
            //res.write("Attempt to send with invalid token via POST");
            //res.end();
          } else if (checaAutorizados(___number).number == ___number){
            //res.write(___number + " - " +___message);

            if (checaToken(___token)){
            client.sendMessage(___number, ___message,{quotedMessageId: ___messageid});
            } else {
              console.log(req.connection.remoteAddress + " - Attempt to send with invalid token via POST");
            }
            //res.end();
          }

          
      });
  }

  

    if (x.query.destination){

        ___number = x.query.destination +"";
        ___message = x.query.message +"";

        ___token = x.query.token;

        console.log(checaToken(___token));

        if (checaAutorizados(___number).number == "00000000000"){
            console.log("Unauthorized number, inform your customer to send a message to authorize.");
            res.write("Unauthorized number, inform your customer to send a message to authorize.");
            res.end();
          } else if (checaAutorizados(___number).number == ___number){

            if (checaToken(___token)){
              client.sendMessage(___number, ___message,{quotedMessageId: null});
              res.write(___number + " - " +___message);
              } else {
                console.log(req.connection.remoteAddress + " - Attempt to send with invalid token via GET");
                res.write(req.connection.remoteAddress + " - Attempt to send with invalid token via GET");
              }

            //client.sendMessage(___number, ___message);
            res.end();
          }


            //console.log(x.query.destination + " - " +x.query.message);
            
    } else {
        switch (req.url){
            case "/unread":
                res.writeHead(200, {"Content-Type": "application/json"});
                res.write(JSON.stringify(unread));
               // res.write(mostraRecebidas());
				//unread = [];

                break;
            case "/":
                
                if (estado == 0){
                    // res.write("Mostra qrcode");

                    var img = fs.readFileSync('./qrcode.png');
                    res.writeHead(200, {'Content-Type': 'image/png' });
                    res.end(img, 'binary');

                } else if (estado == 1){
                    res.write("Already connected");
                }
                
                break;
            default:
                res.write("Wrong path");
        }
        try {
        res.end();
        } catch(e){
            console.log("Nothing to do");
        }
    }
});

server.listen(8080);
console.log('Server is running on port 8080');

