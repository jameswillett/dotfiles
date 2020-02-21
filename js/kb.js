const bplist = require('bplist-parser');

bplist.parseFile(`${process.env.HOME}/Library/Preferences/com.apple.HIToolbox.plist`)
  .then(([result]) => {
    if (!result || !result.AppleSelectedInputSources) return;
    const selectedKeyboard = result.AppleSelectedInputSources.find(
      c => c.InputSourceKind === 'Keyboard Layout'
    );
    if (!selectedKeyboard) return;
    console.log(selectedKeyboard['KeyboardLayout Name']);
  });
