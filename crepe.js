const http = require("http");
const url = require('url');
const fs = require('fs');

const request = require('request');

const qrcode = require("qrcode-terminal");
const { Client, Location, List, Buttons } = require('whatsapp-web.js');

const SESSION_FILE_PATH = './session.json';

let client;

const spam = true;
const checkToken = true;
let mesihba = false;

const chatBot = true;
const chatBotURL = "http://localhost/";
let sessionData;

let sessao;
let sessobj;
let participants = {};
let LocationString = '';
let reminder_timer;

if(fs.existsSync(SESSION_FILE_PATH)) {
    sessao = fs.readFileSync(SESSION_FILE_PATH);
    sessobj = JSON.parse(sessao);

    client = new Client({
      session: sessobj
    });

} else {
  client = new Client();
}



const QRCode = require('qrcode');
const { clearInterval } = require("timers");
const { match } = require("assert");

estado = 0;

let autorizadosArquivo = fs.readFileSync("./autorizados.json");
let autorizados = JSON.parse(autorizadosArquivo);
let MessagesFile = JSON.parse(fs.readFileSync("./Messages.json"));
let token = JSON.parse(fs.readFileSync("./token.json"));



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


client.on('message', message => {
	if(message.body === '!ping') {
		message.reply('pong');
    console.log
	}
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
        client.sendMessage("972544911249-1633190920@g.us", "Hello",{quotedMessageId: "false_972544911249-1633190920@g.us_3EB0ED440D57D7DFE654_972544911249@c.us"});
        //await msg.reply("מתייג את כולם:\n"+text,"", { mentions });
    }
});


async function reminder(chatid) {
    let chat = await client.getChatById(chatid);

    if (!chat.isGroup || !mesihba) {  return; }
    let noresponse_string = '';
    let mentions = [];
    for(let participant of chat.participants) {
    const contact = await client.getContactById(participant.id._serialized);
    if (!(contact.pushname in participants) && !contact.isMe){
        

        noresponse_string += ` @${participant.id.user} `;
        mentions.push(contact)
    }
    }
    if (noresponse_string == '') { clearInterval(reminder_timer); return; }
    let button = new Buttons(MessagesFile.EventBody,[{body:"אגיע"},{body:"לא אגיע"}],"חוזר בשנית: "+MessagesFile.EventTitle+LocationString,MessagesFile.EventFooter);
    if (getComing_full() != '') { noresponse_string += `\n*בנתיים מגיעים:*\n${getComing_full()}`}   
    await client.sendMessage(chatid, `מזכיר עדיין לא עדכנתם ${noresponse_string}`, { mentions });
    await client.sendMessage(chatid, button);
}


function getComing() {
  coming = 0;
  for(var person in participants) {
    var arrive = participants[person];
    if (arrive == 1) {
      coming++;
    }
  }
  return coming;
}

function getComing_full() {
    var arrival_string = '';
    for(var person in participants) {
        var arrive = participants[person];
        if (arrive == 1) {
          arrival_string += `, ${person}`; 
        }
    }
    if (arrival_string == '') {arrival_string = 'וואלה אף אחד לא מגיע';}
    return arrival_string;
}

client.on('message', async (msg) => {
    
    console.log('Message from: ', msg.from, " - ", msg.body);
    const author = await msg.getContact();
    let date = new Date();
    
    unread.push({ timestamp: date.getTime(), messageid: msg.id._serialized, sender: msg.from, sendername: author.pushname ,message: msg.body });

    switch (msg.body) {
      case msg.body.match(/^#התחלנו/)?.input:
        LocationString = msg.body.split("#התחלנו ")[1]
        if(mesihba){
            await msg.reply("קיימת יציאה בתהליך, מספיק עם החלטורות");
            break;
        }
        if(LocationString == undefined || ''){
            await msg.reply("לא נבחר מיקום");
            break;
        }
        mesihba = true;
        //let button = new Buttons("יש מסיבה מגיעים אחים שלי?",[{body:"מגיע"},{body:"לא מגיע אחי"}]);
        let button = new Buttons(MessagesFile.EventBody,[{body:"אגיע"},{body:"לא אגיע"}],MessagesFile.EventTitle+LocationString,MessagesFile.EventFooter);
        await client.sendMessage(msg.from, button);
        chat = await msg.getChat();
        reminder_timer = setInterval(reminder, 1800*1000, msg.from);
        break;
      case "אגיע":
        if (!mesihba) {
          await msg.reply("אין יציאה באופק");
          break;
        }
        if (author.pushname in participants && participants[author.pushname] == 1)
        {
          await client.sendMessage(msg.from, "רשמתי אותך כבר, לא לחפור...",{extra: {
            quotedMsg: {
                body: "אגיע",
                type: "chat"
            },
            quotedStanzaID: 'Some Random shit',
            quotedParticipant: author.id._serialized}});
        }else{
           await client.sendMessage(msg.from, "סבבה רושם אותך",{extra: {
                                                                            quotedMsg: {
                                                                                body: "אגיע",
                                                                                type: "chat"
                                                                            },
                                                                            quotedStanzaID: 'Some Random shit',
                                                                            quotedParticipant: author.id._serialized}});
                                                                
            console.log({ timestamp: date.getTime(), messageid: msg.id._serialized, sender: msg.from, sendername: author.pushname ,message: msg.body });
          participants[author.pushname] = 1;
          await client.sendMessage(msg.from, `${getComing()} כרגע מגיעים`);
        }

        break;
      case "לא אגיע":
        if (!mesihba) {
          await msg.reply(msg.from, "אין יציאה באופק");
          break;
        }
        if (author.pushname in participants)
        {
          if (participants[author.pushname] == 1) {
            await client.sendMessage(msg.from, "קטע מסריח אבל הכל טוב.",{extra: {
                quotedMsg: {
                    body: "לא אגיע",
                    type: "chat"
                },
                quotedStanzaID: 'Some Random shit',
                quotedParticipant: author.id._serialized}});
            participants[author.pushname] = 0;
            await client.sendMessage(msg.from, `${getComing()} כרגע מגיעים`);
          }else{
            //await msg.reply(msg.from, "גם לעשות קטע מסריח וגם לחפור?");
            await client.sendMessage(msg.from, "גם לעשות קטע מסריח וגם לחפור?",{extra: {
                quotedMsg: {
                    body: "לא אגיע",
                    type: "chat"
                },
                quotedStanzaID: 'Some Random shit',
                quotedParticipant: author.id._serialized}});



          }
        }else{
          participants[author.pushname] = 0;
          await client.sendMessage(msg.from, "קיצור אין יציאה יכבאים ימעפנים, יאאלה לכו חפשו מי יארגן לכם יציאות יחברים חרא.");
        }
        break;
      case "מי מגיע?":
        await msg.reply(getComing_full());
        
        break;
      case "#ביטלנו":
        await msg.reply("היציאה בוטלה בהצלחה");
        participants = {};
        meshiba = false;
        clearInterval(reminder_timer);
        break;
      case "בדוק אותי":
        await client.sendMessage(msg.from, 'אני סבבה אחי תודה');
      default:
        break;
    }
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
				        unread = [];

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
