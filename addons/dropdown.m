name = 'Input';
prompt = {'Enter period:';'Enter frequency:'};
%%
formats = struct('type', {}, 'style', {}, 'items', {}, ...
  'format', {}, 'limits', {}, 'size', {});
formats(1,1).type   = 'list';
formats(1,1).style = 'popupmenu';
formats(1,1).items  = {'0','1000', '2000', '3000', '4000'}; % edit the period values here
formats(2,1).type   = 'edit';
formats(2,1).format  = 'integer';
formats(2,1).size = [100 20];
defaultanswers = {4, 10};% 4 is an index from the items in the list, 10 is an integer value
[answer, canceled] = inputsdlg(prompt, name, formats, defaultanswers);