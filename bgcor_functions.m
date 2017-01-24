function h=bgcor_functions

h={@bgcor_load, @get_absolute_path, @find_number, @autoload, @shiftscale, @faktorka, @same_scale,...
    @construct_weight, @polybase, @residuum, @lmmin};

%% load
function [status,filename,file_path,spectra]=bgcor_load(do_test,start_directory,...
FilterSpec,dialog_title,multiselect)
%--------------------------------------------------------------------------
% Nacteni spekter ze souboru (spektra ve sloupcich, 1. sloupec je x-ova skala) 
%--------------------------------------------------------------------------
% Syntaxe funkce:
% [status,filename,file_path,spectra]=readdata(do_test,start_directory,...
% FilterSpec,dialog_title,multiselect)
%--------------------------------------------------------------------------
% Vstupni parametry:
% do_test -> promenna do_test nabyva hodnoty 0,1. Pro hodnotu 1 se testuje,
% jestli je x-ova skala setridena (viz poznamka).
% start_directory -> pocatecni adresar, ktery se vypise v dialogovem okne
% FilterSpec -> 'Cell Array' pro specifikaci typu souboru pro otevreni (tak 
% jak je definovano ve funkci Matlabu 'uigetfile') 
% dialog_title -> retezec, ktery se vypisuje v dialogovem okne 
% multiselect -> 1: vybirame vice souboru, 0: lze vybrat pouze jeden soubor
%--------------------------------------------------------------------------
% Vystupni parametry:
% status -> v pripade stisku cancel pri nacitani dat ma status hodnotu 0.
% V opacnem pripade ma status hodnotu 1.
% filename -> jmeno nacteneho souboru (v pripade, ze se vybira vice souboru
% v rezimu multiselect=1, jsou jmena nactenych souboru v promenne typu Cell
% array).
% file_path -> absolutni cesta k souboru
% spectra -> sloupce v matici spectra odpovidaji jednotlivym nactenym spektrum 
% (prvni sloupec v matici je x-ova skala). v pripade stisku cancel pri
% nacitani dat je spectra=[]
%--------------------------------------------------------------------------
% Poznamka: 1) Pokud prvni sloupec dat (x-ove hodnoty) neni setriden (coz muze
% znacit chybu), pak je nabidnuto jeho vzestupne setrideni. Podle tohoho
% prvniho sloupce se pak setridi ostatni sloupce (spektralni intenzity). S
% takto setridenymi spektry se lepe pracuje pri vykreslovani grafu,
% orezavani, apod.
% 2)  Nacitana Spektra mohou byt ulozena v textovem souboru nebo v binarnim
% souboru (format matlabu: pripona mat). 
%--------------------------------------------------------------------------

% Vyber souboru:
[filename,file_path] = uigetfile(FilterSpec,dialog_title,...
fullfile(start_directory,'*.*'),'Multiselect',multiselect);
if (isequal(filename,0) || isequal(file_path,0)) % stisknuto cancel
 status=0;
 spectra=[];
else
 status=1;   
 spec=strcat(file_path,filename); % specifikace pro nasledne nacteni dat ze souboru
 try
  spectra=load(spec); % nacteni spekter ze souboru (textovy nebo binarni soubor "mat").
 catch
  status=0;
  filename=0;
  file_path=0;
  spectra=[];
  return
 end
 extension=filename((strfind(filename,'.')+1):1:end); % pripona souboru
 if strcmp(extension,'mat') % Spektra se nactou z "mat" souboru 
  polozky_spektra=fieldnames(spectra);   
  spectra=eval(['spectra.' polozky_spektra{1}]); % v souboru "mat" je ulozena
  % pouze jedna promenna (pozadovana spektra)
 end
 if do_test==1 &&  ~issorted(spectra(:,1)) && ~issorted(flipdim(spectra(:,1),1))
  % x-ove hodnoty nejsou setrideny ani vzestupne, ani sestupne -> muze 
  % signalizovat chybu (je nabidnuta moznost spektra vzestupne setridit)
  vypis=['Spectra have unsorted x-values (probably due to the error). '...
  'Do you want to sort them in increasing order ?'];    
  tridit = questdlg(vypis,'Loading data','Yes','No','Yes');
  if strcmp(tridit,'Yes')
   [spectra(:,1),indexy]=sort(spectra(:,1)); % tridi se x-ovy hodnoty
   for i=2:1:size(spectra,2) % y-ovy hodnoty pro kazdy spektrum se tridi podle x
    y=spectra(:,i);
    spectra(:,i)=y(indexy);
   end        
  end
 end
end


%% get_absolute_path
function abs_root_name = get_absolute_path(root_name, curr_path)
[pathstr, name, ext] = fileparts(root_name);
jfile = java.io.File(pathstr);
if jfile.isAbsolute()
    abs_root_name = root_name;
else
    abs_root_name = [curr_path, root_name];
end


%% find_filenumber
function strnumber = find_number(name, index)
I = regexp(name, '\d');

if isempty(I)
    strnumber = [];
    return
end

startI = I(1); 
endI = I(1); 
ii = 1; % current number of group of continuous numbers in string
jj = 2; % current index in the vector of number indices I

% skip all continous numbers till group number `index`
while ii < index
    if jj > length(I)
        strnumber = [];
        return
    end
    if I(jj) ~= I(jj - 1) + 1
        ii = ii + 1;
    end
    jj = jj + 1;
end
startI = I(jj - 1); % set starting index
% go to the last index of this group
while jj <= length(I)
    if I(jj) ~= I(jj - 1) + 1
        break
    else
        jj = jj + 1;
    end
end
endI = I(jj - 1); % set end index

strnumber = name(startI:endI);
        


%% autoload
function [status,spectra]=autoload(settings)
%--------------------------------------------------------------------------
% Try to load spectra automatically
%--------------------------------------------------------------------------
% Syntax:
% [status,spectra]=readdata(settings)
%--------------------------------------------------------------------------
% Input parameters:
% array of structures containing theese parameters
% root_name -> cell containing rootnames of files
% exact -> if the filename should exactly match
% number -> vector of numbers. Each filename can be tested, if it
% contains the number. [] if the number shouldn't be tested.
%--------------------------------------------------------------------------
% Output parameters:
% status -> vector of statuses, 0 indicating that file was loaded, 1
% file was not found, 2 filename is ambiguous, 3 file can't be loaded, 4
% not used
% spectra -> cell of matrixes containing loaded spectra, [] matrix if
% spectrum was not loaded
%--------------------------------------------------------------------------
% Note: Spectra can be in text file or in binary file with mat extension
% Nacitana Spektra mohou byt ulozena v textovem souboru nebo v binarnim
% souboru (format matlabu: pripona mat). 
%--------------------------------------------------------------------------

spectra = cell(length(settings), 1);
status = zeros(length(settings), 1);
filenames = cell(length(settings), 1);

for ii = 1:length(settings)
    if ~settings(ii).use
        status(ii) = 4;
    elseif settings(ii).exact
        fn = [settings(ii).root_name, settings(ii).extension];
        fprintf('checking file %s...', fn);
        if exist(fn, 'file')
            fprintf('succeed.\n');
            filenames{ii} = fn;
        else
            fprintf('not found, failed!\n');
            status(ii) = 1;
        end
    else
        fprintf('autodiscovering file with root %s...\n',...
            settings(ii).root_name);
        [pathstr, name, ext] = fileparts(settings(ii).root_name);
        local_filenames = {};
        listing = dir(pathstr);
        for jj = 1:length(listing)
            if (~listing(jj).isdir)
                fname = listing(jj).name;
                root_L = length(name);
                ext_L = length(settings(ii).extension);
                if length(fname) >= ext_L && length(fname) >= root_L && ...
                        strcmp(name, fname(1:root_L)) &&...
                        strcmp(settings(ii).extension, fname(end - ext_L + 1:end)) &&...
                        (isempty(settings(ii).number) || (~isempty(fname((root_L + 1):(end-ext_L))) &&...
                            ~isempty(strfind(fname((root_L + 1):(end-ext_L)), settings(ii).number))))
                    local_filenames{end + 1} = fname;
                end
            end
        end
        if isempty(local_filenames)
            fprintf('not found, failed!\n');
            status(ii) = 1;
        elseif length(local_filenames) == 1
            fprintf('succeed.\n');
            filenames{ii} = fullfile(pathstr, local_filenames{1});
        else
            fprintf('ambigous, failed!\n');
            status(ii) = 2;
        end
    end
    if ~status(ii)
        fprintf('loading file %s...', filenames{ii});
        try
            spectrum = load(filenames{ii}); % load spectra (text or binary 
            % file "mat").
        catch
            status(ii) = 3;
            fprintf('filed!\n');
            continue
        end
        fprintf('done.\n');
        ext_I = find(filenames{ii} == '.', 1, 'last');
        if ~isempty(ext_I) && strcmp(filenames{ii}(ext_I + 1:end),...
                'mat') % spectra is loaded from "mat" file
            spectrum_fields=fieldnames(spectrum);
            spectra{ii} = eval(['spectrum.' spectrum_fields{1}]); % only
            % one variable is saved in "mat" file.
        else
            spectra{ii} = spectrum;
        end
    end
end


%% shiftscale and its functions
function [data_shifted, xshifts, polypar] = shiftscale(data_orig, bg, polydeg, bgint, polyint, ip)

if nargin < 1
    data_orig = load('pA500pU1000uM_kor.txt','-ascii');
end
if nargin < 2
    bg = load('background\kak255nm70um.txt','-ascii');
end

if nargin < 3
    polydeg = 3;
end

if nargin < 4
    bgint = [2900, 2950];
end

if nargin < 5
    polyint = [2900, 2910, 2960, 2970];
end

x_scale = data_orig(:,1);
spektra_orig = data_orig(:,2:end);

[bgp, bgs, bgshiftx, bgbounds] = paramestimate(bg(:,1), bg(:,2), bgint, polydeg, polyint);
[p, s, shiftx, bounds] = paramestimate(x_scale, spektra_orig, bgint, polydeg, polyint);

% fprintf('%f +- %f\n',[p(2,:);s])
posbg = bgp(2) + bgshiftx;
sposbg = bgs;
pos = sum(p(2,:)./s.^2) / sum(1./s.^2) + shiftx;
spos = 1/sum(1./s.^2);
deltax = posbg - pos;
sdeltax = sqrt(sposbg^2 + spos^2);

if nargin < 6
    ip = 1:size(p,2);
end

px = 1:size(p,2);
polypar = polyfit(px(ip),p(2,ip),1);
deltax2 = posbg - (polyval(polypar, 1:length(p(2,:)))+shiftx);
xshifts = p(2,:);

fprintf('posbg = %f +- %f\n',[posbg;sposbg]);
fprintf('pos = %f +- %f\n',[pos;spos]);
fprintf('deltax = %f +- %f\n',[deltax;sdeltax]);


dx = x_scale(2) - x_scale(1);
x1 = ceil(x_scale(1) + max(deltax2));
x2 = floor(x_scale(end) + min(deltax2));
x_shifted = x1:dx:x2;
data_shifted = zeros(length(x_shifted),size(data_orig,2));
data_shifted(:,1) = x_shifted;
for (kk = 1:size(spektra_orig,2))
    data_shifted(:,kk+1) = spline(x_scale + deltax2(kk), spektra_orig(:,kk), x_shifted);
end


function y = kakpeak(x, p)
y = p(1) * exp( -(x - p(2)).^2 / (2 * p(3)^2) ) + polyval(p(4:end,1), x);

function y = gausspeak(x, p)
y = p(1) * exp( -(x - p(2)).^2 / (2 * p(3)^2) );

function y = dgausspeak(x, p)
 y=[(exp(-(x-p(2)).^2./(2*p(3).^2)))'
  (p(1)*(x-p(2))/p(3)^2.*exp(-(x-p(2)).^2/(2*p(3)^2)))'
  (p(1)*(x-p(2)).^2/(p(3)^3).*exp(-(x-p(2)).^2/(2*p(3)^2)))'];


function [lind, uind] = findint(x, intind)
lind = find(x >= intind(1), 1, 'first');
uind = find(x <= intind(2), 1, 'last');

function P = gaussparm(x, y)
[P(1), I] = max(y);
x1 = x(find(y >= P(1)/2, 1, 'first'));
x2 = x(find(y >= P(1)/2, 1, 'last'));
P(2) = x(I);
P(3) = (x2 - x1) / (2 * sqrt(2 * log(2)));

function [p, s, shiftx, bounds] = paramestimate(x, y, intind, polydeg, polyint)
N = size(y, 2);

p = zeros(4 + polydeg,N);
s = ones(1,N);
func = @gausspeak;
func2 = @kakpeak;
dfunc = @dgausspeak;
[lind, uind] = findint(x, intind);
bounds = [lind, uind];
fitx = x(lind:uind,1);
fity = y(lind:uind, :);
[Y, I] = max(fity(:, 1));
shiftx = x(lind+I-1);
xscale = fitx - shiftx;
[lindp1, uindp1] = findint(x, polyint(1:2));
[lindp2, uindp2] = findint(x, polyint(3:4));
fityp = y([lindp1:uindp1, lindp2:uindp2], :);
xscalep = x([lindp1:uindp1, lindp2:uindp2],1) - shiftx;
for ii = 1:N
    polyP = polyfit(xscalep, fityp(:,ii), polydeg);
    p(end - polydeg:end,ii) = polyP;
    fityg = fity(:,ii) - polyval(polyP, xscale);
    gaussP0 = gaussparm(xscale, fityg);
    k0 = gaussP0(1);
    gaussP0(1) = 1;
    [gaussP,gs,pravdepodobnost,iter] = lmfit2(func,dfunc,xscale,fityg/k0,gaussP0,0,1e2);
    s(ii) = gs(2);
    gaussP(1) = gaussP(1) * k0;
    p(1:3,ii) = gaussP;
    [p(:,ii),sp,pravdepodobnost,iter] = lmfit2(func2,[],xscale,fity(:,ii),p(:,ii),0,1e2);
    s(ii) = sp(2);
end


%% funkce pro vypocet faktorove analyzy
function [U,W,V,E]=faktorka(spektra)
%--------------------------------------------------------------------------
% Faktorova analyza serie spekter
%--------------------------------------------------------------------------
% Syntaxe funkce: [U,W,V,E]=faktorka(spektra)
%--------------------------------------------------------------------------
% Vstupni parametry:
% spektra -> sloupce teto matice odpovidaji exp. spektrum (bez x-oveho
% sloupce)
%--------------------------------------------------------------------------
% Vystupni parametry:
% U -> matice, jejiz sloupce jsou subspektra 
% V -> matice, jejiz sloupce jsou koeficienty
% W -> sloupec singularnich hodnot
% E -> sloupec rezidualnich chyb
%--------------------------------------------------------------------------

% Singular Value Decomposition (SVD). Urceni subspekter U, koeficientu V a
% singularnich hodnot W:
[U,W,V] = svd(spektra,'econ'); 
W=diag(W); % vektor singularnich hodnot

% vypocet rezidualni chyby E v zavislosti na faktorove dimenzi: 
spektra_pocet=size(spektra,2); % pocet spekter  
pocet=size(spektra,1); % pocet spektralnich bodu v jednom spektru
SK=W.^2;% Kvadrat residualni chyby
if spektra_pocet==1 
 E=0; % Pro jedno spektrum nelze definovat rezidualni chybu. E je v tomto
 % pripade definovano jako 0.
else 
 pocet_subspekter=size(U,2); % V pripade, ze pocet spektrálnich bodu >=pocet  
 % spekter, odpovida pocet spekter poctu subspekter. Potom funkce
 % svd(spektra,'econ') je ekvivalentni svd(spektra,0). V opacnem pripade 
 % svd(spektra,'econ') poskytuje mensi pocet subspekter. Pocet subspekter je
 % roven mensimu z parametru (pocet spekter, pocet spektralnich bodu)
 E=zeros(pocet_subspekter-1,1);
 for m=1:(pocet_subspekter-1)
  vyraz_1=sum(SK((m+1):(pocet_subspekter)));
  vyraz_2=pocet*((pocet_subspekter)-m);
  E(m)=sqrt(vyraz_1/vyraz_2); % hodnota rezidualni chyby
 end
end

function spectra = same_scale(spectra) 
L = length(spectra);
indices = zeros(L, 2);
x1 = -1e10;
x2 = 1e10;
% x1 = 420;
% x2 = 2900;
for ii = 1:L
    if spectra{ii}(1,1) > x1
        x1 = spectra{ii}(1,1);
    end
    if spectra{ii}(end,1) < x2
        x2 = spectra{ii}(end,1);
    end
end
for ii = 1:L
    indices(ii,1) = find(spectra{ii}(:,1) == x1);
    indices(ii,2) = find(spectra{ii}(:,1) == x2);
    spectra{ii} = spectra{ii}(indices(ii,1):indices(ii,2),:);
end

function weight = construct_weight(xscale, int)
weight = ones(length(xscale),1);
if xscale(1) < xscale(end)
    k = 1;
else
    k = -1;
end
for ii=1:size(int,1)
    minind=find(k*xscale>=int(ii,1), 1 );
    maxind=find(k*xscale<=int(ii,2), 1, 'last' );
%     fprintf('ii = %d, minind = %d, maxind = %d\n', ii, minind, maxind);
%     fprintf('x(%d) = %d, x(%d) = %d\n', minind, xscale(minind), maxind, xscale(maxind));
%     fprintf('int(%d,1) = %d, x(%d,2) = %d\n', ii, int(ii,1), ii, int(ii,2));
    weight(minind:maxind)=ones(maxind-minind+1,1)*int(ii,3);
end

function [polyb] = polybase(degree,xscale)
polyb = zeros(length(xscale),degree+2);
polyb(:,1) = xscale;
polyb(:,2) = 1 + xscale*0;
for ii=1:degree
    polyb(:,ii+2) = xscale.^ii;
end
% Normalize polynoms
for ii=0:degree
    polyb(:,ii+2) = polyb(:,ii+2)/sqrt(sum(polyb(:,ii+2).^2));
end
% Ortogonalize polynoms
for ii=1:degree
    for jj=0:ii-1
        y = polyb(:,ii+2);
        s = polyb(:,jj+2);
        polyb(:,ii+2) = y - s*sum(y.*s);
    end
    y0 = polyb(:,ii+2);
    polyb(:,ii+2) = y0/sqrt(sum(y0.^2));
end

%% residuum fucntion
function resid = residuum(a, bs, sample, weight, coef)
% resid = residuum(a, bs, sample, koef, weight)
% inputs:
% a       vector of koeficients
% bs      basis matrix containing x scale in the first column and spectra
%         in the next columns
% sample  column spectrum
% weight  scalar or column vector of weights
% coef    multiplicative coefficient of negative differences
% output:
% resid   column vector of residuals

% sum up all backgrounds to one bkg
bkg = bs(:,2:end) * a;

% make differences, negative differences are handicaped by multiplying by
% coef
dif = (sample - bkg) .* weight;
dif_poz = (dif + abs(dif)) / 2;
dif_neg = -coef * (dif - abs(dif)) / 2;
resid = (dif_poz + dif_neg);

%% lmmin and its functions
function [p, sigma, iter] = lmmin(func, dfunc, sumfunc, x, p0, maxit, eps, lambda, mu)
% funkce minalizuje funkci func vuci parametrum p
% Levenberg-Marquardtovou metodou
% pouziti: [p,sigma,pravdepodobnost,iter]...
% =lmmin(func,dfunc,x,p0,sigma,maxit,eps,lambda,mu);
% kde func = fitovana funkce
%     dfunc = funkce pocitajici Jacobian, pokud je zadana prazdna matice []
%             vypocte se jakobian numericky pomoci adaptivniho algoritmu
%             zalozeneho na Rombergove extrapolaci
%     sumfunc = funkce, ktera se pouzije na sumaci rezidui, durazne se
%               doporucuje suma ctvercu, aby spravne fungovala vsechna
%               statistika a normalni rozdeleni chyb
%     x = x-ove souradnice fitovanych bodu
%     p0 = odhad parametru
%     maxit = maximalni pocet iteraci, pocatecni hodnota je 100 (nepovinny parametr)
%     eps = max. odchylka sum rezidui nasledujich iteraci, pocatecni hodnota je 1e-6 (nepovinne)
%     lambda = tlumici faktor pocatecni hodnota je 1e-3 (damping faktor)
%     mu = korekcni faktor pro tlumici faktor pocatecni hodnota je 10
%
% funkce vraci dva sloupcove vektory - p je vektor parametru,
% sigma vektor smerodatnych odchylek, a pocet probehlych iteraci
%

% nastaveni ticheho rezimu, kdy se nic krome chybovych hlasek nevypisuje
% na konzoli:
display_results=0; % 1 pro vypsani vysledku, 0 pro mlceni
extent=1e1; % parametr pro funkci findump, ktery urcuje nejvyssi (+extent)
% a nejnizsi mocnitel (-extent), pomoci kterych se hleda nove lambda
% (lambda*mu^k, kde k=-extent:extent)
 
N=length(x);   % pocet dat
M=length(p0);  % pocet vypresnovanych parametru
 
p0=p0(:);      % timto udelam z p0 sloupcovy vektor
dfunc_control=1;% preinicializace indikatoru, zdali byl na zacatku zadan
                % Jakobian (hodnota 1), nebo se Jakobian bude pocitat
                % numericky (hodnota 0).
 
if (nargin<6) maxit=100;end; % maximalni pocet iteraci
if (nargin<7) eps=1e-6;end; % max. odchylka sum rezidui nasledujich iteraci 
if (nargin<8) lambda=1e-3;end; % tlumici faktor (damping faktor)
if (nargin<9) mu=10;end; % korekce pro tlumici faktor 

if ischar(func)
  func = str2func(func);
end

% pokud je dfunc prazdna matice, vypocte se jakobian numericky
if isempty(dfunc)
 dfunc=@(x,p) jacobianest(@(p) func(x,p),p,eps(1.0))';
 dfunc_control=0;
else
    if ischar(dfunc)
        dfunc = str2func(dfunc);
    end
end
 
% prealokuji pamet na matice a vektory potrebne pro vypocty
J=zeros(M,N);     % Jacobian (M radku, N sloupcu)
 
% nyni spoctu sumu rezidui pro prvotni odhad p0
S0=sumfunc(func(x,p0));
%  S0=sum((y-feval(func,x,p0)).^2);
 deltaS=1;  % prednastavena hodnota rozdilu rezidui
 iter=0;    % pocitadlo iteraci

 % prvni iterace
  p=p0;
  Sn=S0;
 % cyklus vypresnovani
 if ~dfunc_control && display_results
  fprintf('Iterace cislo:\n');
 elseif dfunc_control && display_results
  fprintf('Iterace cislo: 1');
 end
 while (iter<maxit && deltaS>eps);
    if ~dfunc_control && display_results
     fprintf('%d\n',iter+1);
     fprintf('Chy2=%e\n',Sn/(N-M));
     fprintf('deltaS=%e\n',deltaS);
     fprintf('lambda=%e\n',lambda);
    elseif dfunc_control && display_results
     if rem((iter+1),10)==0
      fprintf(',%d',iter+1)
     end
     if rem((iter+1+10),210)==0 && iter+1~=20
      fprintf('\n%d',iter+1)
     end
    end
    % cyklus je ukoncen po dosazeni max.poctu iteraci nebo zadane presnosti
    
    % spoctu matici Jacobianu
    J=dfunc(x,p);
    % spoctu pomocne matice LeveStrany a PraveStrany
    PS=J*(-func(x,p));
    LS0=J*J';
    [p,Sn,lambda]=findamp(func,sumfunc,x,p,PS,LS0,lambda,mu,extent,maxit);
    % odchylka sum rezidui
    deltaS=abs(S0-Sn);
    iter=iter+1;
    S0=Sn;
 end;
 % pokud je dosazeno maximalniho poctu iteraci, zobrazi se
 % varovani
 if (iter>=maxit)
   if dfunc_control && display_results
    fprintf('\n');
   end
   disp('Vypocet zastaven po dosazeni maximalniho poctu iteraci.');
   disp('Zrejme nebylo dosazeno minima.');
   disp('Zadejte jiny pocatecni odhad p0.')
 end;
 % cyklus ukoncen, pocitaji se smerodatne odchylky
 
 % pokud je chikvadrat vetsi nez 1, tak byly chyby nedocenene a tak je
 % treba normovat chyby tak, aby chykvadrat vysel 1
 nu=N-M; % pocet stupnu volnosti
 LS=J*J';
 sigma=diag(sqrt(inv(LS)));
 
 % vypocet rozdilu chy2 od jednicky
%   chi_vb=abs(sum(func(x,p).^2)/nu-1);
 
 
% vypocet pravdepodobnosti chy2
%  pravdepodobnost=1-chi2cdf(nu*(1+chi_vb),nu)+chi2cdf(nu*(1-chi_vb),nu);
% no, a to je vse, zbyva jen vypsat nejak uhledne vysledky
 if ~dfunc_control && display_results
  fprintf('---konec iterovani---\n');
 else
  %fprintf('\n');   
 end
 if display_results
  fprintf('\n');
  fprintf('Po %d iteracich jsem dospel k vysledku:\n',iter);
  for k=1:M
   fprintf('p(%d)=%f +/- %f\n',k,p(k),sigma(k));
  end;
  fprintf('Finalni damping factor je: %e\n\n',lambda);
 end

%%%%%%%%%%%%%%%%%%
% subfunkce pro nelezeni nejlepsiho lambda
%%%%%%%%%%%%%%%%%%

function [p,Sn,lambda]=findamp(func,sumfunc,x,p0,PS,LS0,lambda,mu,extent,maxit)
% [p,Sn,lambda]=findamp(func,x,p0,PS,LS0,lambda,lambda0,mu,extent,
% extent0,maxit)
% nalezne nejlepsi dumping factor lambda pro danou iteraci lmfitu:
%   func = fitovana funkce
%   x = x-ove souradnice fitovanych bodu
%   p0 = parametry pred iteraci
%   PS = vektor prave strany reseni problemu normalnich rovnic
%   LS0 = vektor leve strany reseni problemu normalnich rovnic pouze
%         Newtonovou metodou
%   lambda = tlumici faktor (damping faktor) pred iteraci
%   mu = korekcni faktor pro tlumici faktor
%   extent = urcuje nejvyssi a nejnizsi mocnitel (-extent), pomoci kterych
%         se hleda nove lambda (lambda*mu^k, kde k=-extent:extent)
%   maxit = maximalni pocet iteraci
%
% funkce vraci dva sloupcove vektory - p je vektor parametru,

M=length(p0);
S0=sumfunc(func(x,p0));
lambdan=zeros(2*extent+1,1);
dpn=zeros(M,2*extent+1);
S=ones(2*extent+1,1);
M=eye(M);

% napleni vektoru lambda faktoru, ktere se budou testovat na nejlepsi
% vysledek
for ii=-extent:extent
 index=ii+extent+1;
 lambdan(index)=lambda*mu^ii;
 LSn=LS0+M*lambdan(index);
 dpn(:,index)=LSn\PS;  % tj. inv(LS)*PS
 S(index)=sumfunc(func(x,p0+dpn(:,index)));
end

if isempty(find(S0>S,1)) % neuspel jsem, je treba hledat dal (lambda->lambda*mu^k nebo lambda*mu^-k)
 Sn1=S(end);
 k=extent+1;
 
 while (Sn1>=S0 & k<maxit+extent) % dokud jsem horsi nez predtim
  % pocitam jen levou stranu, prava zustava stejna 
  LS=LS0+M*lambda*mu^k;
  % a nyni uz pocitam posunuti parametru smerem k minimu
  dp1=LS\PS;  % tj. inv(LS)*PS
  Sn1=sumfunc(func(x,p0+dp1));
  k=k+1;
 end
 % nove parametry
 if Sn1<S0
  p=p0+dp1;
  lambda=lambda*mu^(k-1); % nova hodnota lambda
  Sn=Sn1;
 else
  Sn1=S(1);
  k=extent+1;
  while (Sn1>=S0 & k<maxit+extent) % dokud jsem horsi nez predtim
   % pocitam jen levou stranu, prava zustava stejna 
   LS=LS0+M*lambda*mu^-k;
   % a nyni uz pocitam posunuti parametru smerem k minimu
   dp1=LS\PS;  % tj. inv(LS)*PS
   Sn1=sumfunc(func(x,p0+dp1));
   k=k+1;
  end
  % nove parametry
  if Sn1<S0
   p=p0+dp1;
   lambda=lambda*mu^(k-1); % nova hodnota lambda
   Sn=Sn1;
  else % zbyva dodelat pripad, co kdyz se nedari nalezt zadne reseni
   p=p0;
   lambda=lambda;
   Sn=S0;
  end
 end
else % alespon jedno priblizeni je lepsi
 [Sn,ind]=min(S);
 p=p0+dpn(:,ind);
 lambda=lambdan(ind);
end

function J=jacobianest(func,p0,epsilon)
p0=p0(:);   % udela z p0 sloupcovy vektor
M = length(p0);
%epsilon = eps(1.0)
dp = sqrt(epsilon);
delta = zeros(M,1);
delta(1) = dp;
dy1 = (func(p0+delta)-func(p0-delta))/(2*dp);
delta(1) = 0;
N = length(dy1);
J = zeros(N,M);
J(:,1) = dy1;
for ii = 2:M
    delta(ii) = dp;
    J(:,ii) = (func(p0+delta)-func(p0-delta))/(2*dp);
    delta(ii)= 0;
end