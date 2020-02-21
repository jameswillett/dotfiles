const bplist = require('bplist-parser');
const { kb } = require('./emojis');

bplist.parseFile(`${process.env.HOME}/Library/Preferences/com.apple.HIToolbox.plist`)
  .then(([result]) => {
    if (!result || !result.AppleSelectedInputSources) return;
    const selectedKeyboard = result.AppleSelectedInputSources.find(
      c => c.InputSourceKind === 'Keyboard Layout'
    );
    if (!selectedKeyboard) return;
    console.log(kb + ' : ' + selectedKeyboard['KeyboardLayout Name']);
  });
