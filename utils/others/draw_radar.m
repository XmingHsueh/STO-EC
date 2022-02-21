function draw_radar(data,lim,prefer_range,labels,colors,marks)
% figure('color',[1 1 1]);
fig_width = 450;
fig_height = 400;
screen_size = get(0,'ScreenSize');
figure1 = figure('color',[1 1 1],'position',[(screen_size(3)-fig_width)/2, (screen_size(4)-...
    fig_height)/2,fig_width, fig_height]);
set(gca,'units','normal','pos',[0 0 1 1]);
axis off
axis equal
hold on
for q = 1:size(data,2)
    n=length(data(:,q));
    adj_data=zeros(n,1);
    point=zeros(n,2);
    adj_preferl=zeros(n,1);
    preferl_point=zeros(n,2);
    adj_preferu=zeros(n,1);
    preferu_point=zeros(n,2);

    theta_last=pi/2;
    for i=1:n
        theta=2*pi/n*i+pi/2;
        plot([0,500*cos(theta)],[0,500*sin(theta)],'k-','linewidth',0.5);
        oo = linspace(1,5,8);
        for j=1:8
            plot([oo(j)*100*cos(theta_last),oo(j)*100*cos(theta)],[oo(j)*100*sin(theta_last),oo(j)*100*sin(theta)],'--','linewidth',0.5,'color',[0.5,0.5,0.5]);
        end

        theta_last=theta;
        if data(i,q)<lim(i,1)
            adj_data(i)=0;
        elseif data(i,q)>lim(i,2)
            adj_data(i)=500;
        else
            adj_data(i)=(data(i,q)-lim(i,1))/(lim(i,2)-lim(i,1))*500;
        end
        point(i,1:2)=[adj_data(i)*cos(theta);adj_data(i)*sin(theta)];
        adj_preferl(i)=(prefer_range(i,1)-lim(i,1))/(lim(i,2)-lim(i,1))*500;
        preferl_point(i,1:2)=[adj_preferl(i)*cos(theta);adj_preferl(i)*sin(theta)];
        adj_preferu(i)=(prefer_range(i,2)-lim(i,1))/(lim(i,2)-lim(i,1))*500;
        preferu_point(i,1:2)=[adj_preferu(i)*cos(theta);adj_preferu(i)*sin(theta)];
        text_around(510*cos(theta),510*sin(theta),labels{i},theta);
    end

    for i=1:n
        theta=2*pi/n*i+pi/2;
        for j=1:5
        end
    end
    plot([point(:,1);point(1,1)],[point(:,2);point(1,2)],marks{q},'linewidth',2,'markersize',8,'color',colors(q,:));
    texts=findobj(gca,'Type','Text');
    minx=-300;
    maxx=300;
    miny=-300;
    maxy=300;
    for i=1:length(texts)
        rect=get(texts(i),'Extent');
        x=rect(1);
        y=rect(2);
        dx=rect(3);
        dy=rect(4);
        if x<minx
            minx=x;
        elseif x+dx>maxx
            maxx=x+dx;
        end
        if y<miny
            miny=y;
        elseif y+dy>maxy
            maxy=y+dy;
        end
    end
    axis([minx-50,maxx+50,miny-20,maxy+20]);
end
end

function text_around(x,y,txt,theta,fontsize)
if nargin==4
    fontsize=14;
end
section=mod(theta+pi/12,2*pi);
if section>pi+pi/6
    if section>1.5*pi+pi/6
        text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','left','Fontsize',fontsize,'interpret','latex');
    elseif section>1.5*pi
        text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','center','Fontsize',fontsize,'interpret','latex');
    else
        text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','right','Fontsize',fontsize,'interpret','latex');
    end
elseif section>pi
    text(x,y,txt,'VerticalAlignment','middle','HorizontalAlignment','right','Fontsize',fontsize,'interpret','latex');
elseif section>pi/6
    if section>0.5*pi+pi/6
        text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','right','Fontsize',fontsize,'interpret','latex');
    elseif section>0.5*pi
        text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','center','Fontsize',fontsize,'interpret','latex');
    else
        text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','left','Fontsize',fontsize,'interpret','latex');
    end
else
    text(x,y,txt,'VerticalAlignment','middle','HorizontalAlignment','left','Fontsize',fontsize,'interpret','latex');
end
end