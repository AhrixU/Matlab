function bar_texture(pic, hatchs, sizs, wids, clrs1, clrs2, lgdpos, lgdname)

    addpath('./dep')
    %p=bar(...)
    %pic is p
    %hatch length(hatch)=length(pic)
    %      HATCH        pattern
    %     -------      ---------
    %        /          right-slanted lines
    %        \          left-slanted lines
    %        |          vertical lines
    %        -          horizontal lines
    %        +          crossing vertical and horizontal lines
    %        x          criss-crossing lines
    %        .          square dots
    %        c          circular dots
    %        w          Just a blank white pattern
    %        k          Just a totally black pattern
    %sizs ---(arrow) size of hatch(0-1)(符号密度)
    %wids ---(arrow) width of hatch(0-1)(线宽)
    %color---(arrow[3，length(hatch)]) for RGB in [0-1]
    %legdpos-(arrow):[x_position y_position height width spr]
    %==================================================================%
    hold on
    lp = length(pic);

    
    if nargin == 1
        hatchs = repmat('/|\-+x.cwk',[1,ceil(lp/8)]);
        sizs = 0.4 * ones(1, lp); wids = 0.3 * ones(1, lp);
        clrs1 = ones(3,lp); clrs2 = zeros(3,lp);
    end

    gXata = '[';
    gYata = '[';

    for i = 1:lp
        gXata = [gXata ' x{' num2str(i) '}, '];
        gYata = [gYata ' y{' num2str(i) '}, '];
    end

    switch class(pic)
        case 'matlab.graphics.primitive.Patch'
            gXata = [gXata(1:end - 2) ' ] = pic.XData;'];
            gYata = [gYata(1:end - 2) ' ] = pic.YData;'];
            eval([gXata]); eval([gYata]);
        case 'matlab.graphics.chart.primitive.Bar'
            gXata = [gXata(1:end - 2) ' ] = pic.XEndPoints;'];
            gYata = [gYata(1:end - 2) ' ] = pic.YEndPoints;'];
            eval([gXata]); eval([gYata]);

            spr0 = x{2}(1, 1) - x{1}(1, 1);
            q = pic.BarWidth;
            spr0 = spr0 * q(1);

            for i = 1:lp
                x{i}(3, :) = x{i}(1, :) + spr0 / 2;
                y{i}(3, :) = y{i}(1, :);
                x{i}(1, :) = x{i}(3, :) - spr0;
                y{i}(1, :) = 0;
            end

        otherwise
            disp('oops~not a bar?~')

    end

    a = axis;
    X = a(2) - a(1);
    Y = a(4) - a(3);
    x0 = x{1}(1, 1);
    x1 = x{1}(3, 1);
    q = (x1 - x0) / X;

    for i = 1:lp

        for j = 1:length(x{i}(1, :))

            x0 = x{i}(1, j);
            x1 = x{i}(3, j);
            y0 = y{i}(1, j);
            y1 = y{i}(3, j);

            l2 = floor(100 * (x1 - x0) / X) / q;
            l1 = floor(100 * (y1 - y0) / Y) / q;
            hatched = makehatch_plus(hatchs(i), sizs(i) * 100, wids(i) * 100 * sizs(i));
            hatched = 1 - hatched;

            for cls = 1:3
                hat(:, :, cls) = hatched .* (clrs1(cls, i) - clrs2(cls, i));
                hat(:, :, cls) = hat(:, :, cls) + clrs2(cls, i);
            end

            hatching = repmat(hat, [ceil(l1 / 100 / sizs(i)), ceil(l2 / 100 / sizs(i))]);
            hatching = hatching(1:l1, 1:l2, :);
            %size(hatching)
            n = 0.0001;
            image([x0 + n * X x1 - n * X], [y0 + n * Y y1 - n * Y], hatching)
            plot([x0 x0 x1 x1 x0], [y0 y1 y1 y0 y0], 'black')
            clear hat hatching hatched
        end

    end
    b=gca;
    fs=b.FontSize;
    if nargin == 8

        for i = 1:lp
            %legdpos-(arrow):[x_position y_position height width spr]
            x0 = lgdpos(1);
            x1 = lgdpos(1) + lgdpos(4);
            y1 = lgdpos(2) - (i - 1) * (lgdpos(3) + lgdpos(5));
            y0 = lgdpos(2) - (i) * lgdpos(3) - (i - 1) * lgdpos(5);
            text(x1 + 0.01 * X, (y0 + y1) / 2, lgdname(i),'FontSize',fs)
            l2 = floor(100 * (x1 - x0) / X) / q;
            l1 = floor(100 * (y1 - y0) / Y) / q;
            hatched = makehatch_plus(hatchs(i), sizs(i) * 100, wids(i) * 100 * sizs(i));
            hatched = 1 - hatched;

            for cls = 1:3
                hat(:, :, cls) = hatched .* (clrs1(cls, i) - clrs2(cls, i));
                hat(:, :, cls) = hat(:, :, cls) + clrs2(cls, i);
            end

            hatching = repmat(hat, [ceil(l1 / 100 / sizs(i)), ceil(l2 / 100 / sizs(i))]);
            hatching = hatching(1:l1, 1:l2, :);
            %size(hatching)
            n = 0.00;
            image([x0 + n * X x1 - n * X], [y0 + n * Y y1 - n * Y], hatching)
            plot([x0 x0 x1 x1 x0], [y0 y1 y1 y0 y0], 'black')
            clear hat hatching hatched
        end

    end
    xlim([a(1) a(2)])
    ylim([a(3) a(4)])
